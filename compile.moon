IDENT = "    "

moon = require"moon"

level = 0
actionContext = true
compile_line = (ast, ast2) ->

    moon.p(ast)
    
    if ast2
        moon.p(ast2)
        error"we have ast2 infection!"

    unless ast
        return ""

    if type(ast) == "number"
        print ""
        return ""

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
            actionContext = false
        when "tagEnd"
            level -= 1
            line ..= "}" -- .. "--" .. ast.tagEnd
        -- else
        --     return false

    if comment = ast.comment
        line ..= comment\gsub("#", "--")

    return ident! .. line

return compile_line

