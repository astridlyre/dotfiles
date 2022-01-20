-- Snippet Support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

local flags = { debounce_text_changes = 150, allow_incremental_sync = true }

return function()
	-- Null LS
	local null_ls = require("null-ls")
	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics
	local code_actions = null_ls.builtins.code_actions

	null_ls.setup({
		sources = {
			formatting.joker,
			formatting.prettierd,
			formatting.shfmt,
			formatting.black,
			formatting.fixjson,
			formatting.goimports,
			formatting.isort,
			formatting.fnlfmt,
			formatting.sqlformat,
			formatting.stylua,
			diagnostics.shellcheck,
			diagnostics.eslint_d.with({
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				extra_args = { "--config", vim.fn.expand("~/.eslintrc.json") },
			}),
			diagnostics.proselint.with({ filetypes = { "markdown", "tex", "text" } }),
			diagnostics.write_good.with({ filetypes = { "markdown", "tex", "text" } }),
			diagnostics.misspell.with({
				filetypes = { "markdown", "tex", "text" },
			}),
			diagnostics.flake8,
			diagnostics.vint,
			diagnostics.yamllint,
			code_actions.eslint_d,
			code_actions.proselint,
		},
		capabilities = capabilities,
		flags = flags,
	})
end
