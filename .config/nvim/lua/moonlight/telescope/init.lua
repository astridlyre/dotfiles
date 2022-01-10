return function()
	local telescope = require("telescope")
	telescope.setup({
		defaults = {
			prompt_prefix = " ",
			selection_caret = "→ ",
			path_display = { "smart" },
		},
	})
end
