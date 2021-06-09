-- Lsp Configs
local lspconfig = require('lspconfig')
local lsp_config = {}

-- Diagnostic Signs
vim.fn.sign_define("LspDiagnosticsSignError", {
    texthl = "LspDiagnosticsSignError",
    text = "",
    numhl = "LspDiagnosticsSignError"
})
vim.fn.sign_define("LspDiagnosticsSignWarning", {
    texthl = "LspDiagnosticsSignWarning",
    text = "",
    numhl = "LspDiagnosticsSignWarning"
})
vim.fn.sign_define("LspDiagnosticsSignHint", {
    texthl = "LspDiagnosticsSignHint",
    text = "",
    numhl = "LspDiagnosticsSignHint"
})
vim.fn.sign_define("LspDiagnosticsSignInformation", {
    texthl = "LspDiagnosticsSignInformation",
    text = "",
    numhl = "LspDiagnosticsSignInformation"
})

-- symbols for autocomplete
vim.lsp.protocol.CompletionItemKind = {
    "   ", "   ", "   ", "   ", " ﴲ  ", "[] ", "   ",
    " ﰮ  ", "   ", " 襁 ", "   ", "   ", " 練 ", "   ",
    "   ", "   ", "   ", "   ", "   ", "   ", " ﲀ  ",
    " ﳤ  ", "   ", "   ", "   "
}

-- Normal keymap function
local function nmap(keymap, action, opts)
    return vim.api.nvim_set_keymap('n', keymap, action, opts)
end

-- LSP Keymaps
local lsp_maps = function(bufnr)
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

-- Generic On-Attach Function
local on_attach = function(client, bufnr)
    lsp_maps(bufnr)
    if client.config.flags then
        client.config.flags.allow_incremental_sync = true
    end
end

-- Snippet Support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {'documentation', 'detail', 'additionalTextEdits'}
}

-- Diagnostic Handlers
local diagnostics = {
    virtual_text = {spacing = 0, prefix = ""},
    signs = {enable = true, priority = 20},
    underline = true,
    update_in_insert = false
}

-- Set Default Prefix.
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, diagnostics)

-- clangd
local function clangd()
    lspconfig.clangd.setup {
        cmd = {
            "clangd", "--background-index", "--suggest-missing-includes",
            "--clang-tidy", "--header-insertion=iwyu"
        },
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp
                                                                   .diagnostic
                                                                   .on_publish_diagnostics,
                                                               diagnostics)
        }
    }
end

-- Deno for TypeScript
local function denols()
    lspconfig.denols.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        init_options = {enable = true, lint = true, unstable = false},
        filetypes = {"typescript", "typescriptreact", "typescript.tsx"},
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp
                                                                   .diagnostic
                                                                   .on_publish_diagnostics,
                                                               diagnostics)
        }
    }
end

-- efm language server
local function efm()
    -- Vim linting
    local vim_vint = {
        lintCommand = 'vint -',
        lintStdin = true,
        lintFormats = {'%f:%l:%c: %m'}
    }

    -- Markdown Lint & Formatting
    local markdown = {
        lintCommand = 'markdownlint -s',
        lintStdin = true,
        lintFormats = {'%f:%l %m', '%f:%l:%c %m', '%f: %l: %m'},
        formatCommand = 'prettier --parser markdown',
        formatStdin = true
    }

    -- Yaml Linting
    local yaml_lint = {lintCommand = 'yamllint -f parsable -', lintStdin = true}

    -- Shell formatting & linting
    local shell = {
        lintCommand = 'shellcheck -f gcc -x',
        lintSource = 'shellcheck',
        lintFormats = {
            '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m',
            '%f:%l:%c: %tote: %m'
        },
        formatCommand = 'shfmt -ci -s -bn',
        formatStdin = true
    }

    -- Lua formatting
    local lua_fmt = {formatCommand = 'lua-format -i', formatStdin = true}

    -- Rust formatting
    local rust_fmt = {
        formatCommand = 'rustfmt --emit stdout',
        formatStdin = true
    }

    -- Python formatting & Linting
    local python_lint = {
        lintCommand = 'mypy --show-column-numbers',
        lintFormats = {
            '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m',
            '%f:%l:%c: %tote: %m'
        },
        lintStdin = true
    }
    local python_fmt = {formatCommand = 'black --quiet -', formatStdin = true}
    local python_isort = {formatCommand = 'isort --quiet -', formatStdin = true}
    local python_flake = {
        lintCommand = 'flake8 --stdin-display-name ${INPUT} -',
        lintStdin = true,
        lintFormats = {'%f:%l:%c: %m'}
    }

    -- HTML Formatting
    local html_fmt = {
        formatCommand = 'prettier --parser html',
        formatStdin = true
    }

    -- CSS Formatting
    local css_fmt = {
        formatCommand = 'prettier --parser css',
        formatStdin = true
    }

    -- JSON Formatting
    local json = {
        formatCommand = 'fixjson',
        lintCommand = 'jq .',
        formatStdin = true,
        lintStdin = true
    }

    lspconfig.efm.setup {
        init_options = {
            documentFormatting = true,
            hover = false,
            documentSymbol = false,
            codeAction = false,
            completion = false
        },
        root_dir = function() return vim.fn.getcwd() end,
        filetypes = {
            "sh", "rust", "vim", "lua", "python", "yaml", "markdown", "html",
            "css", "sass", "json", "text"
        },
        settings = {
            rootMarkers = {".git/"},
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
end

-- Go Language Server
local function gopls()
    lspconfig.gopls.setup {
        cmd = {"gopls", "--remote=auto"},
        settings = {
            gopls = {analyses = {unusedparams = true}, staticcheck = true}
        },
        root_dir = lspconfig.util.root_pattern(".git", "go.mod", "."),
        init_options = {usePlaceholders = true, completeUnimported = true},
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp
                                                                   .diagnostic
                                                                   .on_publish_diagnostics,
                                                               diagnostics)
        }
    }
end

-- Rust Analyzer
local function rust_analyzer()
    lspconfig.rust_analyzer.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp
                                                                   .diagnostic
                                                                   .on_publish_diagnostics,
                                                               diagnostics)
        },
        settings = {
            ['rust-analyzer'] = {
                checkOnSave = {
                    allFeatures = true,
                    overrideCommand = {
                        'cargo', 'clippy', '--workspace',
                        '--message-format=json', '--all-targets',
                        '--all-features'
                    }
                }
            }
        }
    }
end

-- Sumneko Language Server
local function sumneko_lua()
    local sumneko_root_path = vim.fn.getenv("HOME") ..
                                  "/.local/lua-language-server"
    local sumneko_binary_path = "/bin/Linux/lua-language-server"

    lspconfig.sumneko_lua.setup {
        cmd = {
            sumneko_root_path .. sumneko_binary_path, "-E",
            sumneko_root_path .. "/main.lua"
        },
        on_attach = on_attach,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    path = vim.split(package.path, ';')
                },
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
            ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp
                                                                   .diagnostic
                                                                   .on_publish_diagnostics,
                                                               diagnostics)
        }
    }
end

-- TSserver for javacript (nodejs support)
local function tsserver()
    lspconfig.tsserver.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = {"javascript", "javascript.jsx", "javascriptreact"},
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp
                                                                   .diagnostic
                                                                   .on_publish_diagnostics,
                                                               diagnostics)
        }
    }
end

lsp_config.configure = function()
    -- Enable the following language servers
    local servers = {
        'pyright', 'yamlls', 'vimls', 'html', 'cssls', 'dockerls', 'cmake',
        'bashls', 'clangd'
    }

    -- Loop and set them up
    for _, ls in ipairs(servers) do
        lspconfig[ls].setup {on_attach = on_attach, capabilities = capabilities}
    end

    clangd()
    denols()
    efm()
    gopls()
    rust_analyzer()
    sumneko_lua()
    tsserver()
end

return lsp_config
