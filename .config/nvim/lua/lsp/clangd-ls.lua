-- clangd
require'lspconfig'.clangd.setup {
    cmd = {
        "clangd", "--background-index", "--suggest-missing-includes",
        "--clang-tidy", "--header-insertion=iwyu"
    },
    on_attach = require'lsp'.on_attach,
    capabilities = require'lsp'.capabilities,
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic
                                                               .on_publish_diagnostics,
                                                           require'lsp'.diagnostics)
    }
}
