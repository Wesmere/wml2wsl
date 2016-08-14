moon = require "moon"

IDENT = "    "

{
    :R, :S, :V, :P, :C, :Ct, :Cmt, :Cg, :Cb, :Cc
} = require "lpeg"

{
    :White, :Break, :Stop, :Comment, :Space, :SomeSpace, :SpaceBreak, :EmptyLine,
    :AlphaNum, :Num, :Shebang, :L
    Name: _Name
} = require "wml2wsl.parse.literals"

{
    :Indent, :Cut, :ensure, :extract_line, :mark, :pos, :flatten_or_mark,
    :is_assignable, :check_assignable, :format_assign, :format_single_assign,
    :sym, :symx, :simple_string, :wrap_func_arg, :join_chain,
    :wrap_decorator, :check_lua_string, :self_assign
} = require "wml2wsl.parse.util"



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

-- a constructor for quote delimited strings
simple_string = (delim, allow_interpolation) ->
    inner = P("\\#{delim}") + "\\\\" + (1 - P delim)

    inner = if allow_interpolation
        interp = symx'#{' * V"Exp" * sym'}'
        (C((inner - interp)^1) + interp / mark"interpolate")^0
    else
        C inner^0

    symx(delim) * C(inner) * sym(delim) / mark_value"string"








Space = plain_space

Variable = (sym"$" * (Name / mark_value"variable") * sym"|"^0) -- / mark2("type", variable)

DoubleString = Space * simple_string('"')
TString = (Space * sym"_" * Space * DoubleString) / mark2("type","tstring")

Comment = Ct(Cg( plain_space * "#" * (1 - S"\r\n")^0,"comment") )^0


notName = P(1- S",# {}")^1 -- notName = C R("az", "AZ", "__") * AlphaNum^0
UnquotedString = White * C(notName * (White * notName)^0) / mark_value("string")


Number = S" "^0 * (Num / mark_value("number") ) * ( #(SomeSpace + S",}") + L(Stop) )

g = P {
    "Line"
    Value: Number + Variable + TString + DoubleString + UnquotedString + V"PureMacro" + V"Macro"
    Line: (V"Macro" + V"PureMacro" + V"TagStart" + V"TagEnd" + V"Attribute" )^0 * Comment * L(Stop)

    TagStart: (sym"["  * Name * symx"]") / mark_value("tagStart")
    TagEnd:   (sym"[/" * Name * symx"]") / mark_value("tagEnd")

    KeyList:   Cg(Ct(Name * (sym"," * Name)^0),"keys")
    ValueList: Cg(Ct(V"Value" * (sym"," * (V"Value"))^0   ),"values")
    Attribute: Ct(Space * V"KeyList" * sym"=" * V"ValueList" ) / mark2("type","attribute")

    PureMacro: sym"{" * (Name / mark_value"pureMacro") * sym"}"
    Macro: ((Ct(sym"{" * Cg(Name,"name") * Space * Cg(Ct(V"Value" * (SomeSpace * V"Value")^0 ),"parameters") * sym"}")) ) / mark2("type", "macro")
    -- Macro: ((Ct(sym"{" * Cg(Name,"name") * Space * Cg(Ct(V"Value" * (SomeSpace * V"Value")^0 ),"parameters") * sym"}")) * Comment) / mark2("type", "macro")
}


level = 0
actionContext = true
compile = (ast) ->
    unless ast
        return false

    -- moon.p(ast)

    old_level = level
    line = ""

    ident = ->
        space = ""

        for i = 1, math.min(level, old_level)
            space ..= IDENT
        return space

    compile_value = (value) ->
        unless value
            return ""

        str = ""
        value_type = value.type
        switch value_type
            when "tstring"
                str ..= "_ " .. '"' .. value.value .. '"'
            when "string"
                str ..= '"' .. value.value .. '"'
            when "number"
                str ..= value.value
            when "variable"
                str ..= value.value
            when "pureMacro"
                str ..= value.value
            when "macro"
                str ..= value.name .. "("
                last = #value.parameters
                for i, arg in ipairs value.parameters
                    str ..= compile_value(arg)
                    str ..= ", " if i != last
                str ..= ")"
            else
                moon.p(value)
                error("value type unknown: " .. value_type)
        return str


    nodeType = ast.type

    switch nodeType
        when "macro"
            line ..= compile_value(ast)
            -- line ..= ast.name .. "(" .. (compile_value ast.macro.value) .. ")"
        when "pureMacro"
            line ..= compile_value(ast)

        when "attribute"
            if #ast.keys == 1
                line ..= ast.keys[1] .. ": "
                line ..= "{" if #ast.values > 1
                first = true
                for value in *ast.values
                    line ..= ", " unless first
                    first = false
                    line ..= compile_value(value)
                line ..= "}" if #ast.values > 1
            else
                first = true
                for i, key in ipairs ast.keys
                    line ..= ", " unless first
                    line ..= key .. ": " .. compile_value(ast.values[i])
                    first = false
        when "tagStart"
            line ..= ast.value .. (if actionContext then "" else ": ") .. "{"
            level += 1
        --     actionContext = false
        when "tagEnd"
            level -= 1
            line ..= "}" -- .. "--" .. ast.tagEnd
        -- else
        --     return false

    if comment = ast.comment
        line ..= comment\gsub("#", "--")

    print ident! .. line
    return true


-- file = io.open("./spec/inputs/01_Defend_the_Forest.cfg", "r")
file = io.open("./spec/inputs/simple.cfg", "r")           --01_Defend_the_Forest.cfg", "r")
input = {}
-- output = {}

-- -- parser = "wml2wsl/parse"

for line in file\lines!
    table.insert(input, line)


for i, line in ipairs input

    -- print line .. " :>"
    -- moon.p(g\match(line))

    if ast = g\match(line)
        moon.p(ast)
        unless compile(ast)
            print "Compile Error at line " .. i .. ": " .. line
            -- moon.p(ast)
    else
        print "Parse Error at line " .. i .. ": " .. line

    -- table.insert(output, "#{g\match(line)}")


-- for line in *output
    -- print line



-- P(string) matches "string" literally
-- P(n) matches exactly n characters

-- S(string) matches any character in "string" (Set)

-- R("xy") matches any character between "x" and "y" (Range)

-- V(v) This operation creates a non-terminal (a variable) for a grammar.

-- B(patt)
