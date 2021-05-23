-- Treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {enable = true},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<M-w>',
            node_incremental = '<M-w>',
            scope_incremental = '<M-e>',
            node_decremental = '<M-C-w>'
        }
    }
}

-- LSP settings
local nvim_lsp = require('lspconfig')
local on_attach = function(_client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- Enable the following language servers
local servers = {
    'clangd', 'rust_analyzer', 'pyright', 'tsserver', 'bashls', 'gopls',
    'yamlls', 'vimls', 'html', 'cssls'
}
for _, lsp in ipairs(servers) do nvim_lsp[lsp].setup {on_attach = on_attach} end

-- Sumneko Language Server
local sumneko_root_path = vim.fn.getenv("HOME") .. "/.local/lua-language-server"
local sumneko_binary_path = "/bin/Linux/lua-language-server"
nvim_lsp.sumneko_lua.setup {
    cmd = {
        sumneko_root_path .. sumneko_binary_path, "-E",
        sumneko_root_path .. "/main.lua"
    },
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
            diagnostics = {globals = {'vim'}},
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                }
            }
        }
    }
}

require"lspconfig".efm.setup {
    init_options = {
        documentFormatting = true,
        hover = true,
        documentSymbol = true,
        codeAction = true,
        completion = true
  },
}

-- Compe setup
require'compe'.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,
    source = {path = true, buffer = true, nvim_lsp = true}
}
