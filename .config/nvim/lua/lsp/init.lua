-- Lsp Configs
local nvim_lsp = require('lspconfig')

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

-- Object to export
local lsp_config = {}

-- Generic On-Attach Function
lsp_config.on_attach = function(client, bufnr)
    lsp_maps(bufnr)
    if client.config.flags then
        client.config.flags.allow_incremental_sync = true
    end
end

-- Snippet Support
lsp_config.capabilities = vim.lsp.protocol.make_client_capabilities()
lsp_config.capabilities.textDocument.completion.completionItem.snippetSupport =
    true
lsp_config.capabilities.textDocument.completion.completionItem.resolveSupport =
    {properties = {'documentation', 'detail', 'additionalTextEdits'}}

-- Diagnostic Handlers
lsp_config.diagnostics = {
    virtual_text = {spacing = 0, prefix = ""},
    signs = true,
    underline = true,
    update_in_insert = false
}

-- Enable the following language servers
local servers = {
    'clangd', 'rust_analyzer', 'pyright', 'yamlls', 'vimls', 'html', 'cssls',
    'dockerls', 'cmake', 'bashls'
}

-- Loop and set them up
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = lsp_config.on_attach,
        capabilities = lsp_config.capabilities
    }
end

-- Special On-Attach for TSServer to disable formatting
function lsp_config.tsserver_on_attach(client, bufnr)
    lsp_config.on_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = false
end

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

-- Set Default Prefix.
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                 lsp_config.diagnostics)

-- symbols for autocomplete
vim.lsp.protocol.CompletionItemKind = {
    "   ", "   ", "   ", "   ", " ﴲ  ", "[] ", "   ",
    " ﰮ  ", "   ", " 襁 ", "   ", "   ", " 練 ", "   ",
    "   ", "   ", "   ", "   ", "   ", "   ", " ﲀ  ",
    " ﳤ  ", "   ", "   ", "   "
}

return lsp_config
