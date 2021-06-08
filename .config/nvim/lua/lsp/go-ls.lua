-- Go Language Server
require'lspconfig'.gopls.setup {
    cmd = {"gopls", "--remote=auto"},
    settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true}},
    root_dir = require'lspconfig'.util.root_pattern(".git", "go.mod", "."),
    init_options = {usePlaceholders = true, completeUnimported = true},
    on_attach = require'lsp'.on_attach,
    capabilities = require'lsp'.capabilities,
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic
                                                               .on_publish_diagnostics,
                                                           require'lsp'.diagnostics)
    }
}
