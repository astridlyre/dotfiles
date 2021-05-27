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
-- snippetSupport
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {'documentation', 'detail', 'additionalTextEdits'}
}

-- Enable the following language servers
local servers = {
    'clangd', 'rust_analyzer', 'pyright', 'bashls', 'gopls', 'yamlls', 'vimls',
    'html', 'cssls', 'tsserver'
}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {on_attach = on_attach, capabilities = capabilities}
end

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

-- efm config
local vim_vint = {
    lintCommand = 'vint -',
    lintStdin = true,
    lintFormats = {'%f:%l:%c: %m'}
}
local markdown = {
    lintCommand = 'markdownlint -s',
    lintStdin = true,
    lintFormats = {'%f:%l %m', '%f:%l:%c %m', '%f: %l: %m'},
    formatCommand = 'prettier --parser markdown'
}
local yaml_lint = {lintCommand = 'yamllint -f parsable -', lintStdin = true}
local shell = {
    lintCommand = 'shellcheck -f gcc -x',
    lintSource = 'shellcheck',
    lintFormats = {
        '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'
    },
    formatCommand = 'shfmt -ci -s -bn',
    formatStdin = true
}
local lua_fmt = {formatCommand = 'lua-format -i', formatStdin = true}
local rust_fmt = {formatCommand = 'rustfmt --emit stdout', formatStdin = true}
local python_lint = {
    lintCommand = 'mypy --show-column-numbers',
    lintFormats = {
        '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'
    }
}
local python_fmt = {formatCommand = 'black --quiet -', formatStdin = true}
local python_isort = {formatCommand = 'isort --quiet -', formatStdin = true}
local python_flake = {
    lintCommand = 'flake8 --stdin-display-name ${INPUT} -',
    lintStdin = true,
    lintFormats = {'%f:%l:%c: %m'}
}
local html_fmt = {formatCommand = 'prettier --parser html'}
local css_fmt = {formatCommand = 'prettier --parser css'}
local json = {formatCommand = 'fixjson', lintCommand = 'jq .'}

-- Formatting and linting
nvim_lsp.efm.setup {
    init_options = {
        documentFormatting = true,
        hover = true,
        documentSymbol = true,
        codeAction = true,
        completion = true
    },
    root_dir = function() return vim.fn.getcwd() end,
    filetypes = {"sh", "go", "rust", "vim", "lua", "python", "yaml"},
    settings = {
        formattting_seq = true,
        languages = {
            vim = {vim_vint},
            markdown = {markdown},
            yaml = {yaml_lint},
            sh = {shell},
            lua = {lua_fmt},
            rust = {rust_fmt},
            python = {python_lint, python_fmt, python_isort, python_flake},
            json = {json},
            html = {html_fmt},
            css = {css_fmt},
            sass = {css_fmt}
        }
    }
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
