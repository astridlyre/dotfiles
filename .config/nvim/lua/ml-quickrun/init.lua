local qr = {
    go = {'go run ', 'go test '},
    c = {'make-n-run '},
    lua = {'lua '},
    py = {'python ', 'pytest '},
    js = {'node '},
    ts = {'deno run '}
}

function qr.run_command(test)
    local cmd = nil
    local file_type = vim.fn.expand("%:e")
    local file_name = vim.fn.expand("%:p")
    if file_type == 'go' then
        if file_name:match("_test") or test then
            cmd = qr[file_type][2]
        else
            cmd = qr[file_type][1]
        end
    elseif file_type == 'py' then
        if file_name:match("test_") or test then
            cmd = qr[file_type][2]
        else
            cmd = qr[file_type][1]
        end
    else
        cmd = qr[file_type][1]
    end
    local output_list = vim.fn.split(vim.fn.system(cmd .. file_name), '\n')
    for _, v in ipairs(output_list) do print(v) end
end

return qr
