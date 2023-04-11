local wezterm = require("wezterm")

return {
	warn_about_missing_glyphs = false,
	keys = {
		{ key = "Enter", mods = "SHIFT|CTRL", action = wezterm.action.SpawnWindow },
		{ key = "Space", mods = "SHIFT|CTRL", action = wezterm.action.SpawnWindow },
	},
	font = wezterm.font_with_fallback({ "PragmataPro Mono Liga", "PragmataProMonoLiga Nerd Font" }),
	font_size = 12,
	color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
	enable_tab_bar = false,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}
