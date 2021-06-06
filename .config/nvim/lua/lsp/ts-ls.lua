-- TSserver for javacript (nodejs support)
require"lspconfig".tsserver.setup {
    on_attach = require'lsp'.on_attach,
    capabilities = require'lsp'.capabilities,
    filetypes = {"javascript", "javascript.jsx", "javascriptreact"},
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic
                                                               .on_publish_diagnostics,
                                                           require'lsp'.diagnostics)
    }
}
