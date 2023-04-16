return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		version = false,
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				integrations = {
					gitsigns = true,
					telescope = true,
					mini = true,
					leap = true,
					neotree = true,
					cmp = true,
					semantic_tokens = true,
					treesitter = true,
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
						},
					},
				},
				custom_highlights = function(colors)
					return {
						WinSeparator = { fg = colors.surface2 },
						FloatBorder = { fg = colors.surface2 },
						CmpBorder = { fg = colors.surface2 },
						CmpDocBorder = { fg = colors.surface2 },
						BorderFloat = { fg = colors.surface2 },
						BorderBG = { fg = colors.surface2 },
						NullLsInfoBorder = { fg = colors.surface2 },
					}
				end,
			})
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},
}
