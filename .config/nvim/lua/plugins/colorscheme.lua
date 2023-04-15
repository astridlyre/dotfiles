return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		version = false,
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				integrations = { mini = true, leap = true, neotree = true },
				custom_highlights = function(colors)
					return { WinSeparator = { fg = colors.surface2 } }
				end,
			})
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},
}
