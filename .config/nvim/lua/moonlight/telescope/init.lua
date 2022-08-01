return function()
	local telescope = require("telescope")
	telescope.setup({
		defaults = {
			prompt_prefix = "❯ ",
			selection_caret = "  ",
			path_display = { "smart" },
			sorting_strategy = "ascending",
			layout_strategy = "flex",
			layout_config = {
				horizontal = { prompt_position = "top", preview_width = 0.55 },
				vertical = { mirror = false },
				width = 0.87,
				height = 0.8,
				preview_cutoff = 120,
			},
			dynamic_preview_title = true,
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
					"!**/.cache/**",
					"--glob",
					"!**/.mypy_cache/**",
					"--glob",
					"!**/dist/**",
					"--glob",
					"!**/.parcel-cache/**",
					"--glob",
					"!*.min.js",
					"--max-filesize",
					"1M",
					"--glob",
					"!*.{jpg,png,gif}",
				},
			},
		},
	})
	telescope.load_extension("fzf")
end
