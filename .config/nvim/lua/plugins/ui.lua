return {
	{ "folke/lazy.nvim", version = "*" },
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},
	{
		'nvim-mini/mini.nvim',
		version = false,
		config = function()
			require("mini.statusline").setup({
				content = {
					active = function()
						local MiniStatusline = require("mini.statusline")
						local mode, mode_hl  = MiniStatusline.section_mode({ trunc_width = 120 })
						local git            = MiniStatusline.section_git({ trunc_width = 120 })
						local diff           = MiniStatusline.section_diff({ trunc_width = 75 })
						local diagnostics    = MiniStatusline.section_diagnostics({ trunc_width = 75 })
						local lsp            = MiniStatusline.section_lsp({ trunc_width = 75 })
						local filename       = MiniStatusline.section_filename({ trunc_width = 140 })
						local location       = MiniStatusline.section_location({ trunc_width = 75 })
						local search         = MiniStatusline.section_searchcount({ trunc_width = 75 })

						return MiniStatusline.combine_groups({
							{ hl = mode_hl,                 strings = { mode } },
							{ hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
							'%<', -- Mark general truncate point
							{ hl = 'MiniStatuslineFilename', strings = { filename } },
							'%=', -- End left alignment
							{ hl = mode_hl,                  strings = { search, location } },
						})
					end,
					inactive = nil
				},
				use_icons = true

			})

			local hipatterns = require('mini.hipatterns')
			hipatterns.setup({
				highlighters = {
					-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
					fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
					hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
					todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
					note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

					-- Highlight hex color strings (`#rrggbb`) using that color
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})

			require('mini.pairs').setup()
		end
	},
	{
		'Verf/deepwhite.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd [[colorscheme deepwhite]]
			vim.api.nvim_set_hl(0, "QuickFixLine", { fg = "#000000", bg = "#D4FAD4" })
			vim.api.nvim_set_hl(0, "LeapLabel", { fg = "#ffffff", bg = "#000000" })
		end,
	},
	-- lazy.nvim
	{
		'saghen/blink.indent',
		--- @module 'blink.indent'
		--- @type blink.indent.Config
		opts = {
			static = {
				char = '│',
			},
			scope = {
				char = '│',
				highlights = { 'BlinkIndentScope' },
			}
		},
	},
	{
		'andymass/vim-matchup',
		-- or use the `opts` mechanism built into `lazy.nvim`. It calls
		-- `require('match-up').setup` under the hood
		---@type matchup.Config
		opts = {
			treesitter = {
				stopline = 500,
			}
		}
	}

}
