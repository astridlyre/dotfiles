local ui = {}

-- Lualine
function ui.lualine()
	local function theme()
		local colors = {
			black = "#1b1b20",
			white = "#b4b4b9",
			red = "#ff3600",
			green = "#718e3f",
			blue = "#635196",
			yellow = "#ffc552",
			gray = "#57575e",
			darkgray = "#36363a",
			lightgray = "#dfdfe5",
			inactivegray = "#28282d",
		}
		return {
			normal = {
				a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
				b = { bg = colors.gray, fg = colors.lightgray },
				c = { bg = colors.darkgray, fg = colors.lightgray },
			},
			insert = {
				a = { bg = colors.red, fg = colors.black, gui = "bold" },
				b = { bg = colors.gray, fg = colors.lightgray },
				c = { bg = colors.darkgray, fg = colors.lightgray },
			},
			visual = {
				a = { bg = colors.green, fg = colors.black, gui = "bold" },
				b = { bg = colors.gray, fg = colors.lightgray },
				c = { bg = colors.darkgray, fg = colors.lightgray },
			},
			replace = {
				a = { bg = colors.blue, fg = colors.black, gui = "bold" },
				b = { bg = colors.gray, fg = colors.lightgray },
				c = { bg = colors.darkgray, fg = colors.lightgray },
			},
			command = {
				a = { bg = colors.green, fg = colors.black, gui = "bold" },
				b = { bg = colors.gray, fg = colors.lightgray },
				c = { bg = colors.darkgray, fg = colors.lightgray },
			},
			inactive = {
				a = { bg = colors.gray, fg = colors.gray, gui = "bold" },
				b = { bg = colors.inactivegray, fg = colors.gray },
				c = { bg = colors.inactivegray, fg = colors.gray },
			},
		}
	end
	require("lualine").setup({
		options = {
			theme = theme(),
			section_separators = "",
			component_separators = "",
			padding = 1,
		},
	})
end

-- Attach Colorizer to these filetypes
function ui.colorizer()
	require("colorizer").setup({
		"css",
		"javascript",
		"html",
		"yaml",
		"sass",
		"markdown",
		"lua",
		"typescript",
		"vim",
		"sh",
		"bash",
		"scss",
	})
end

-- Git Signs
function ui.gitsigns()
	require("gitsigns").setup({
		signs = {
			add = { hl = "GitGutterAdd", text = "▋" },
			change = { hl = "GitGutterChange", text = "▋" },
			delete = { hl = "GitGutterDelete", text = "▋" },
			topdelete = { hl = "GitGutterDeleteChange", text = "▔" },
			changedelete = { hl = "GitGutterChange", text = "▎" },
		},
		keymaps = {
			-- Default keymap options
			noremap = true,
			buffer = true,

			["n ]g"] = {
				expr = true,
				"&diff ? ']g' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'",
			},
			["n [g"] = {
				expr = true,
				"&diff ? '[g' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'",
			},

			["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
			["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
			["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
			["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
			["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',

			-- Text objects
			["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
			["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
		},
	})
end

return ui
