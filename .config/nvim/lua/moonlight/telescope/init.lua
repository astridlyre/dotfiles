return function()
	local telescope = require("telescope")
	telescope.setup({
		defaults = {
			prompt_prefix = " ",
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
				find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
			},
		},
	})
	telescope.load_extension("fzf")
end
