-- Sumneko Language Server
local sumneko_root_path = vim.fn.getenv("HOME") .. "/.local/lua-language-server"
local sumneko_binary_path = "/bin/Linux/lua-language-server"

require"lspconfig".sumneko_lua.setup {
    cmd = {
        sumneko_root_path .. sumneko_binary_path, "-E",
        sumneko_root_path .. "/main.lua"
    },
    on_attach = require'lsp'.on_attach,
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
            diagnostics = {globals = {'vim'}},
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                },
                maxPreload = 10000
            }
        }
    },
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic
                                                               .on_publish_diagnostics,
                                                           require'lsp'.diagnostics)
    }
}

