return function()
	-- Snippet Support
	local lsp = require("moonlight.lsp")
	local capabilities = lsp.make_capabilities()
	local flags = lsp.flags
	local enable_formatting_on_save = true

	-- Null LS
	local null_ls = require("null-ls")
	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics
	local code_actions = null_ls.builtins.code_actions

	null_ls.setup({
		sources = {
			formatting.raco_fmt,
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
			diagnostics.staticcheck,
			diagnostics.eslint_d.with({
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
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
		on_attach = function(client)
			if enable_formatting_on_save then
				if client.resolved_capabilities.document_formatting then
					vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
				autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]])
				end
			end
		end,
	})
end
