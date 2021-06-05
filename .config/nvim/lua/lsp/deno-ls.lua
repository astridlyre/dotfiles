-- Deno for TypeScript
require"lspconfig".denols.setup {
    on_attach = require"lsp".on_attach,
    capabilities = require"lsp".capabilities,
    init_options = {enable = true, lint = true, unstable = false},
    filetypes = {"typescript", "typescriptreact", "typescript.tsx"},
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic
                                                               .on_publish_diagnostics,
                                                           require'lsp'.diagnostics)
    }
}

