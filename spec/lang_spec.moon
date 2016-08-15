wml2wsl = require"wml2wsl"

options = {
    in_dir: "spec/inputs"
    out_dir: "spec/outputs"
    input_pattern: "(.*)%.cfg$"
    output_ext: ".moon"

    diff: {
        tool: "git diff --no-index --color" --color-words"
    }

}


diff_file = (a_fname, b_fname) ->
    out = io.popen(options.diff.tool .. " ".. a_fname .. " " .. b_fname, "r")\read "*a"
    if options.diff.filter
        out = options.diff.filter out
    out

diff_str = (expected, got) ->
    a_tmp = os.tmpname! .. ".expected"
    b_tmp = os.tmpname! .. ".got"

    with io.open(a_tmp, "w")
        \write expected
        \close!

    with io.open(b_tmp, "w")
        \write got
        \close!

    with diff_file a_tmp, b_tmp
        os.remove a_tmp
        os.remove b_tmp

inputs = for file in lfs.dir options.in_dir
    with match = file\match options.input_pattern
        continue unless match


describe "input tests", ->

    for name in *inputs
        print name

        it name .. " #input", ->

            tmp_file_path = os.tmpname! .. ".got"
            out_file_path = options.out_dir .. "/" .. name .. options.output_ext

            wml2wsl.transcompile_file(options.in_dir .. "/" .. name .. ".cfg", tmp_file_path)

            diff_out = diff_file(tmp_file_path, out_file_path)
            -- diff_out = diff_file(out_file_path,tmp_file_path) 

            print diff_out
            assert(diff_out == '')
