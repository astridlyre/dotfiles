return {
	{
		"neovim/nvim-lspconfig",
		version = false,
		config = function()
			require("moonlight.lsp").setup()
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		version = false,
		dependencies = { "nvim-lspconfig" },
		config = function()
			local lsp = require("moonlight.lsp")
			local capabilities = lsp.make_capabilities()
			-- local flags = lsp.flags

			-- Null LS
			local null_ls = require("null-ls")
			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics

			null_ls.setup({
				sources = {
					formatting.joker.with({ filetypes = { "clojure", "clj" } }),
					formatting.prettierd,
					formatting.shfmt,
					formatting.black,
					formatting.fixjson,
					formatting.goimports,
					formatting.isort,
					formatting.stylua,
					diagnostics.clj_kondo,
					diagnostics.shellcheck,
					diagnostics.staticcheck,
					diagnostics.write_good.with({ filetypes = { "markdown", "tex", "text" } }),
					diagnostics.flake8,
					diagnostics.vint,
					diagnostics.yamllint,
					diagnostics.stylelint,
					require("typescript.extensions.null-ls.code-actions"),
					null_ls.builtins.code_actions.gitsigns,
				},
				capabilities = capabilities,
				-- flags = flags,
				on_attach = function(client)
					if client.server_capabilities.documentFormattingProvider then
						vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
				autocmd BufWritePre <buffer> lua require('moonlight.autoformat').format()
            augroup END
            ]])
					end
				end,
			})
		end,
	},
	{ "jose-elias-alvarez/typescript.nvim", lazy = true, version = false },
}
