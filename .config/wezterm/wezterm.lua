local wezterm = require("wezterm")

return {
	warn_about_missing_glyphs = false,
	keys = {
		{ key = "Enter", mods = "SHIFT|CTRL", action = wezterm.action.SpawnWindow },
		{ key = "Space", mods = "SHIFT|CTRL", action = wezterm.action.SpawnWindow },
	},
	font = wezterm.font_with_fallback({ "PragmataPro Mono Liga", "PragmataProMonoLiga Nerd Font" }),
	font_size = 12,
	colors = {
		background = "#14161b",
		-- Overrides the cell background color when the current cell is occupied by the
		-- cursor and the cursor style is set to Block
		cursor_bg = "#eef1f8",
		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = "black",
		-- Specifies the border color of the cursor when the cursor style is set to Block,
		-- or the color of the vertical or horizontal bar when the cursor style is set to
		-- Bar or Underline.
		cursor_border = "#eef1f8",

		-- the foreground color of selected text
		selection_fg = "black",
		-- the background color of selected text
		selection_bg = "#9b9ea4",

		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = "#2c2e33",

		-- The color of the split lines between panes
		split = "#2c2e33",

		ansi = {
			"#14161b",
			"#ffc0b9",
			"#b3f6c0",
			"#fce094",
			"#a6dbff",
			"#ffcaff",
			"#8cf8f7",
			"#eef1f8",
		},
		brights = {
			"#4f5258",
			"#ffc0b9",
			"#b3f6c0",
			"#fce094",
			"#a6dbff",
			"#ffcaff",
			"#8cf8f7",
			"#eef1f8",
		},
	},
	enable_tab_bar = false,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}
