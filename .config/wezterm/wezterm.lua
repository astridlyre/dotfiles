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
		-- The default text color
		foreground = "#c6c6c6",
		-- The default background color
		background = "#000000",
		-- Overrides the cell background color when the current cell is occupied by the
		-- cursor and the cursor style is set to Block
		cursor_bg = "#ffffff",
		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = "#000000",
		-- Specifies the border color of the cursor when the cursor style is set to Block,
		-- or the color of the vertical or horizontal bar when the cursor style is set to
		-- Bar or Underline.
		cursor_border = "#c6c6c6",
		-- the foreground color of selected text
		selection_fg = "#000000",
		-- the background color of selected text
		selection_bg = "#ffd787",
		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = "#222222",
		-- The color of the split lines between panes
		split = "#222222",
		ansi = {
			"#000000",
			"#EF6C6C",
			"#5faf5f",
			"#B48F6A",
			"#7799BB",
			"#d787d7",
			"#5fafaf",
			"#c6c6c6",
		},
		brights = {
			"#767676",
			"#ff5f5f",
			"#5fd75f",
			"#ffd787",
			"#5fafff",
			"#ff87ff",
			"#5fd7d7",
			"#ffffff",
		},
		-- Colors for copy_mode and quick_select
		-- available since: 20220807-113146-c2fee766
		-- In copy_mode, the color of the active text is:
		-- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
		-- 2. selection_* otherwise
		copy_mode_active_highlight_bg = { Color = "#000000" },
		-- use `AnsiColor` to specify one of the ansi color palette values
		-- (index 0-15) using one of the names "Black", "Maroon", "Green",
		--  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
		-- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
		copy_mode_active_highlight_fg = { AnsiColor = "Black" },
		copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
		copy_mode_inactive_highlight_fg = { AnsiColor = "White" },
		quick_select_label_bg = { Color = "peru" },
		quick_select_label_fg = { Color = "#ffffff" },
		quick_select_match_bg = { AnsiColor = "Navy" },
		quick_select_match_fg = { Color = "#ffffff" },
	},
	enable_tab_bar = false,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}
