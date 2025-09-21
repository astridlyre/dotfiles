return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters.raco_review = {
				cmd = 'raco',
				stdin = false,
				append_fname = true,
				ignore_exitcode = true,
				args = { 'review' },
				parser = require('lint.parser').from_pattern("([^:]+):(%d+):(%d+):(%w+):(.+)",
					{ 'file', 'lnum', 'col', 'severity', 'message' }, {
						error = vim.diagnostic.severity.ERROR,
						warning = vim.diagnostic.severity.WARN,
						info = vim.diagnostic.severity.INFO,
						hint = vim.diagnostic.severity.HINT,
					}, { ['source'] = 'review' })
			}

			lint.linters_by_ft = { python = { "pylint" }, racket = { "raco_review" }, clojure = { 'clj-kondo' } }

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>ll", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},
}
