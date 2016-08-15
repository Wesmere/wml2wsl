
{
    :R, :S, :V, :P, :C, :Ct, :Cmt, :Cg, :Cb, :Cc
} = require "lpeg"
lpeg = require "lpeg"
L = lpeg.luversion and lpeg.L or (v) -> #v


------------------- literals

White = S" \t\r\n"^0
plain_space = S" \t"^0

Break = P"\r"^-1 * P"\n"
Stop = Break + -1

Comment = plain_space * "#" * (1 - S"\r\n")^0 * L(Stop)
Space = plain_space * Comment^-1
SomeSpace = S" \t"^1 * Comment^-1

SpaceBreak = Space * Break
EmptyLine = SpaceBreak

AlphaNum = R "az", "AZ", "09", "__"

Name = C R("az", "AZ", "__") * AlphaNum^0

Num = P"0x" * R("09", "af", "AF")^1 * (S"uU"^-1 * S"lL"^2)^-1 +
    R"09"^1 * (S"uU"^-1 * S"lL"^2) +
    (
        R"09"^1 * (P"." * R"09"^1)^-1 +
        P"." * R"09"^1
    ) * (S"eE" * P"-"^-1 * R"09"^1)^-1

-------------------- /literals

mark2 = (key, value) ->
    (tab) ->
        return unless tab
        tab[key] = value
        return tab

mark_value = (type_name) ->
    (value) -> {
            type: type_name
            value: value
        }

komisch = ->
    (ast1, ast2) ->
        ast1.comment = ast2.comment if ast2
        return ast1




Space = plain_space


-- a symbol
sym = (chars) -> Space * chars
-- a symbol that doesn't accept whitespace before it
symx = (chars) -> chars


-- a constructor for quote delimited strings
simple_string = (delim, allow_interpolation) ->
    inner = P("\\#{delim}") + "\\\\" + (1 - P delim)

    inner = if allow_interpolation
        interp = symx'#{' * V"Exp" * sym'}'
        (C((inner - interp)^1) + interp / mark"interpolate")^0
    else
        C inner^0

    symx(delim) * C(inner) * sym(delim) / mark_value"string"



Variable = sym"$" * (Name / mark_value"variable") * sym"|"^0

DoubleString = Space * simple_string('"')
TString = (Space * sym"_" * Space * DoubleString) / mark2("type","tstring")

Comment = Ct(Cg( plain_space * "#" * (1 - S"\r\n")^0,"comment") )^0

notName = P(1- S",# {}")^1
UnquotedString = White * C(notName * (White * notName)^0) / mark_value("string")

Number = S" "^0 * (Num / mark_value("number") ) * ( #(SomeSpace + S",}") + L(Stop) )


g = P {
    "Line"
    Line: ((V"Macro" + V"PureMacro" + V"TagStart" + V"TagEnd" + V"Attribute")^0 * Comment) * L(Stop) / komisch!

    Value: Number + Variable + TString + DoubleString + UnquotedString + V"PureMacro" + V"Macro"

    TagStart: (sym"["  * Name * symx"]") / mark_value("tagStart")
    TagEnd:   (sym"[/" * Name * symx"]") / mark_value("tagEnd")

    KeyList:   Cg(Ct(Name * (sym"," * Name)^0),"keys")
    ValueList: Cg(Ct(V"Value" * (sym"," * (V"Value"))^0   ),"values")
    Attribute: Ct(Space * V"KeyList" * sym"=" * V"ValueList" ) / mark2("type","attribute")

    PureMacro: sym"{" * (Name / mark_value"pureMacro") * sym"}"
    Macro: Ct(sym"{" * Cg(Name,"name") * Space * Cg(Ct(V"Value" * (SomeSpace * V"Value")^0 ),"parameters") * sym"}") / mark2("type", "macro")
}


parse = (line) ->
    ast = g\match(line)
    return ast

return parse
