local capabilities = require("/user/plugins/lsp").capabilities
local on_attach = require("/user/plugins/lsp").on_attach

return function()
	-- Null LS
	local null_ls = require("null-ls")
	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics

	null_ls.setup({
		sources = {
			formatting.prettierd,
			formatting.shfmt,
			formatting.black,
			formatting.fixjson,
			formatting.goimports,
			formatting.isort,
			formatting.sqlformat,
			formatting.rustfmt,
			formatting.stylua,
			diagnostics.shellcheck,
			diagnostics.eslint_d.with({
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				extra_args = { "--config", vim.fn.expand("~/.eslintrc.json") },
			}),
			diagnostics.flake8,
			diagnostics.markdownlint,
			diagnostics.vint,
		},
		on_attach = on_attach,
		capabilities = capabilities,
	})
end
