return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")


			conform.setup({
				formatters = {
					raco = { command = "raco", args = 'fmt' }
				},
				formatters_by_ft = {
					-- javascript = { "prettierd" },
					-- typescript = { "prettierd" },
					-- javascriptreact = { "prettierd" },
					-- typescriptreact = { "prettierd" },
					javascript = { "biome" },
					typescript = { "biome" },
					javascriptreact = { "biome" },
					typescriptreact = { "biome" },
					svelte = { "prettierd" },
					css = { "biome" },
					html = { "prettierd" },
					json = { "biome" },
					yaml = { "prettierd" },
					markdown = { "prettierd" },
					graphql = { "biome" },
					lua = { "stylua" },
					python = { "isort", "black" },
					go = { "gofmt", "goimports" },
					bash = { "shfmt" },
					sh = { "shfmt" },
					racket = { "raco" },
					clojure = { "cljstyle" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>lf", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},
}
