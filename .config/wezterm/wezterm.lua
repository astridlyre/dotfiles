local wezterm = require("wezterm")

return {
	warn_about_missing_glyphs = false,
	keys = {
		{ key = "Enter", mods = "SHIFT|CTRL", action = wezterm.action.SpawnWindow },
	},
	font = wezterm.font_with_fallback({ "PragmataPro Liga", "PragmataProMonoLiga Nerd Font" }),
	font_size = 12,
	colors = {
		-- The default text color
		foreground = "#ddd8bb",
		-- The default background color
		background = "#1f1f28",

		-- Overrides the cell background color when the current cell is occupied by the
		-- cursor and the cursor style is set to Block
		cursor_bg = "#9ec967",
		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = "#000000",
		-- Specifies the border color of the cursor when the cursor style is set to Block,
		-- or the color of the vertical or horizontal bar when the cursor style is set to
		-- Bar or Underline.
		cursor_border = "#9ec967",

		-- the foreground color of selected text
		selection_fg = "#9ec967",
		-- the background color of selected text
		selection_bg = "#000000",

		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = "#222222",

		-- The color of the split lines between panes
		split = "#3c3c51",

		ansi = {
			"#1F1F28",
			"#E46A78",
			"#98BC6D",
			"#E5C283",
			"#7EB3C9",
			"#957FB8",
			"#7EB3C9",
			"#DDD8BB",
		},
		brights = {
			"#3C3C51",
			"#EC818C",
			"#9EC967",
			"#F1C982",
			"#7BC2DF",
			"#A98FD2",
			"#7BC2DF",
			"#A8A48D",
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
