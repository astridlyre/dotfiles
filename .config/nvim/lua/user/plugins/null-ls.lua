local capabilities = require("user/plugins/lsp").capabilities
local on_attach = require("user/plugins/lsp").on_attach
local flags = require("user/plugins/lsp").flags

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
			formatting.sqlformat,
			-- formatting.rustfmt,
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
		},
		on_attach = on_attach,
		capabilities = capabilities,
		flags = flags,
	})
end
