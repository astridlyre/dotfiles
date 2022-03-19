return function()
	local telescope = require("telescope")
	telescope.setup({
		defaults = {
			prompt_prefix = "❯ ",
			selection_caret = "→ ",
			path_display = { "smart" },
			preview = {
				filesize_hook = function(filepath, bufnr, opts)
					local max_bytes = 10000
					local cmd = { "head", "-c", max_bytes, filepath }
					require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
				end,
			},
		},
		pickers = {
			find_files = {
				find_command = {
					"rg",
					"--files",
					"--hidden",
					"--glob",
					"!**/node_modules/**",
					"--glob",
					"!**/build/**",
					"--glob",
					"!**/.git/**",
					"--glob",
					"!**/.npm-packages/**",
					"--glob",
					"!**/.cache/**",
					"--glob",
					"!**/.mypy_cache/**",
					"--glob",
					"!**/.icons/**",
					"--glob",
					"!**/.themes/**",
					"--glob",
					"!**/dist/**",
					"--glob",
					"!**/.parcel-cache/**",
					"--glob",
					"!*.min.js",
					"--max-filesize",
					"1M",
				},
			},
		},
	})
	telescope.load_extension("fzf")
end
