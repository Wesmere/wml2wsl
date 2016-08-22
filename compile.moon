IDENT = "    "

moon = require"moon"

actionWrappers = {"do", "command", "then", "else"}
actionTags = {"message", "scenario", "set_variables", "random_placement", "unit", "kill", "endlevel", "objectives"}
ambigTags = {"unit", "event"}



trim = (s) ->
  return (s\gsub("^%s*(.-)%s*$", "%1"))





build_compiler = ->
    level = 0
    actionContext = true

    tagStack = {}
    popStack = (tagName) ->
        if tagStack[#tagStack] != tagName
            print "Unbalanced WML"
            -- error"Unbalanced WML!"
        else
            table.remove(tagStack)

    actionWrappersMap = {}
    for tag in *actionWrappers
        actionWrappersMap[tag] = true

    actionTagMap = {}
    for tag in *actionTags
        actionTagMap[tag] = true

    isInActionContext = (tagname) ->
        context = tagStack[#tagStack]

        switch context
            when "event"
                switch tagname
                    when "filter"
                        return false
                    else
                        return true
            when "do"
                return true
            when "command"
                return true
            when nil
                return true


    getTagType = (tagname) ->
        assert(tagname)
        context = tagStack[#tagStack]
        if actionWrappersMap[tagname]
            return "wrapper"

        switch context
            when "event"
                if actionTagMap[tagname]
                    return "initial"
                else
                    return "key"
            when "then"
                return "action"
            when "else"
                return "action"
            when "do"
                return "action"
            when "command"
                return "action"
            when nil
                return "action"
            else
                return "key"
        assert(false)


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

        local compile_node

        compile_attribute = (node) ->
            line = ""
            if #node.keys == 1
                line ..= node.keys[1] .. ": "
                line ..= "{" if #node.values > 1
                first = true
                for value in *node.values
                    line ..= ", " unless first
                    first = false
                    line ..= compile_node(value)
                line ..= "}" if #node.values > 1
            else
                first = true
                for i, key in ipairs node.keys
                    line ..= ", " unless first
                    line ..= key .. ": " .. compile_node(node.values[i])
                    first = false
            return line

        compile_node = (node) ->
            unless node
                return ""

            str = ""
            node_type = node.type
            node_value = node.value
            switch node_type
                when "bool"
                    switch node_value
                        when "yes"
                            str ..= "true"
                        when "no"
                            str ..= "false"
                        else
                            error"Unknown Boolean value #{node_value}"
                when "tstring"
                    str ..= "_ " .. '"' .. node_value .. '"'
                when "string"
                    str ..= '"' .. node_value .. '"'
                when "number"
                    str ..= node_value
                when "variable"
                    str ..= node_value
                when "pureMacro"
                    str ..= node_value .. "!"
                when "macro"
                    str ..= node.name .. "("
                    last = #node.parameters
                    for i, arg in ipairs node.parameters
                        str ..= compile_node(arg)
                        str ..= ", " if i != last
                    str ..= ")"
                when "attribute"
                    str ..= "{"
                    str ..= compile_attribute(node)
                    str ..= "}"
                else
                    moon.p(node)
                    error("node type unknown: " .. node_type)
            return str

        nodeType = ast.type

        switch nodeType
            when "macro"
                if tagStack[#tagStack] == "event"
                    line ..= "do: -> "
                    level += 1
                    actionContext = true
                    table.insert(tagStack, "do")
                line ..= compile_node(ast)
                -- line ..= ast.name .. "(" .. (compile_value ast.macro.value) .. ")"
            when "pureMacro"
                line ..= compile_node(ast)

            when "attribute"
                line ..= compile_attribute(ast)

            when "tagStart"
                tagName = ast.value
                tagType = getTagType(tagName)
                if tagType == "initial"
                    line ..= "do: -> "
                    level += 1
                    table.insert(tagStack, "do")
                line ..= tagName
                switch tagType
                    when "action"
                        line ..= "{"
                    when "key"
                        line ..= ": {"
                    when "wrapper"
                        if tagName == "event"
                            line ..= ": {"
                        else
                            line ..= ": ->"
                    when "initial"
                        line ..= "{"
                    when nil
                        error"TagType is nil"
                    else
                        error"Unknown Tag Type" .. tagType
                level += 1
                -- actionContext = false
                table.insert(tagStack, ast.value)
            when "tagEnd"
                if ast.value == "event"
                    level -= 1
                    popStack("do")
                level -= 1
                line ..= "}" unless actionWrappersMap[ast.value]
                popStack(ast.value)

                -- if tagStack[#tagStack] == ast.value
                --     table.remove(tagStack)
                --     if tagStack[#tagStack] == "do"
                --         actionContext = true
                -- else
                --     error"Unbalanced WML: #{ast.value} blah #{tagStack[#tagStack]}"
            when "ifDef"
                line ..= "if " .. ast.value .. " then { _merge:"
                level += 1
                table.insert(tagStack, "ifDef")
            when "endIf"
                line ..= "}"
                level -= 1
                table.remove(tagStack)
            when "define"
                table.insert(tagStack, "define")
                line ..= ast.name .. " = ("
                if parameters = ast.parameters
                    for i, id in ipairs parameters
                        line ..= id.value
                        line ..= ", " if i != #parameters
                line ..= ") ->"
                level += 1
            when "enddef"
                level -= 1
                table.remove(tagStack)
            when nil
                {}
            else
                error"unknown type: #{nodeType}"

        if comment = ast.comment
            comment = trim(comment) if #line == 0
            line ..= comment\gsub("#", "--")

        unless #line == 0
            line = ident! .. line
        return line
    return compile_line

return build_compiler

