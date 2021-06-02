-- Lsp Configs
local nvim_lsp = require('lspconfig')

local function nmap(keymap, action, opts)
    return vim.api.nvim_set_keymap('n', keymap, action, opts)
end

-- LSP settings
local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local opts = {noremap = true, silent = true}
    nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    nmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    nmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    nmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    nmap('gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    nmap('<leader>lk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    nmap('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    nmap('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
         opts)
    nmap('<leader>wp',
         '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
         opts)
    nmap('<leader>ld', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    nmap('<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    nmap('<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    nmap('<leader>le',
         '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    nmap('<leader>ln', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    nmap('<leader>lp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    nmap('<leader>lq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    nmap('<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Snippet Support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {'documentation', 'detail', 'additionalTextEdits'}
}

-- Enable the following language servers
local servers = {
    'clangd', 'rust_analyzer', 'pyright', 'bashls', 'gopls', 'yamlls', 'vimls',
    'html', 'cssls'
}

-- Loop and set them up
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

-- Deno for Javascript and TypeScript
nvim_lsp.denols.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {enable = true, lint = true, unstable = false}
}

-- efm-langserver linting and formatting
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
    filetypes = {
        "sh", "rust", "vim", "lua", "python", "yaml", "markdown", "html", "css",
        "sass", "json"
    },
    settings = {
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
    source = {path = true, buffer = true, nvim_lsp = true, vsnip = true}
}

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

-- Lualine
local function theme()
    local colors = {
        black = '#1b1b20',
        white = '#b4b4b9',
        red = '#ff3600',
        green = '#718e3f',
        blue = '#635196',
        yellow = '#ffc552',
        gray = '#57575e',
        darkgray = '#36363a',
        lightgray = '#dfdfe5',
        inactivegray = '#28282d'
    }
    return {
        normal = {
            a = {bg = colors.yellow, fg = colors.black, gui = 'bold'},
            b = {bg = colors.gray, fg = colors.lightgray},
            c = {bg = colors.darkgray, fg = colors.lightgray}
        },
        insert = {
            a = {bg = colors.red, fg = colors.black, gui = 'bold'},
            b = {bg = colors.gray, fg = colors.lightgray},
            c = {bg = colors.darkgray, fg = colors.lightgray}
        },
        visual = {
            a = {bg = colors.green, fg = colors.black, gui = 'bold'},
            b = {bg = colors.gray, fg = colors.lightgray},
            c = {bg = colors.darkgray, fg = colors.lightgray}
        },
        replace = {
            a = {bg = colors.blue, fg = colors.black, gui = 'bold'},
            b = {bg = colors.gray, fg = colors.lightgray},
            c = {bg = colors.darkgray, fg = colors.lightgray}
        },
        command = {
            a = {bg = colors.green, fg = colors.black, gui = 'bold'},
            b = {bg = colors.gray, fg = colors.lightgray},
            c = {bg = colors.darkgray, fg = colors.lightgray}
        },
        inactive = {
            a = {bg = colors.gray, fg = colors.gray, gui = 'bold'},
            b = {bg = colors.inactivegray, fg = colors.gray},
            c = {bg = colors.inactivegray, fg = colors.gray}
        }
    }
end
require('lualine').setup {
    options = {
        theme = theme(),
        section_separators = '',
        component_separators = '',
        padding = 1
    }
}
