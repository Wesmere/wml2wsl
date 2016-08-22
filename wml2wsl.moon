
compile_line = require"compile"
parse_line = require"parse"

transcompile_line = (line, compiler) ->
    ast = parse_line(line)

    line = compiler(ast)
    return line

transcompile_file = (input, output) ->

    compiler = compile_line!

    print "trans compiling " .. input .. " into " .. output


    input_file = io.open(input, "r")
    output_file = io.open(output, "w")


    for line in input_file\lines!
        code = transcompile_line(line, compiler)
        output_file\write(code .. '\n')

    output_file\close!

{
    :transcompile_file
}
