return {
	{
		'echasnovski/mini.statusline',
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
		end
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufRead", "BufNewFile" },
		version = false,
		config = function()
			local gitsigns = require("gitsigns")
			gitsigns.setup({
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
			})
		end,
		keys = {
			{ "<leader>gh", ":Gitsigns stage_hunk<cr>",                                     desc = 'Git Stage Hunk' },
			{ "<leader>gr", ":Gitsigns reset_hunk<cr>",                                     desc = 'Git Reset Hunk' },
			{ "<leader>gH", ":Gitsigns undo_stage_hunk<cr>",                                desc = 'Git Undo Stage Hunk' },
			{ "<leader>ga", ":Gitsigns stage_buffer<cr>",                                   desc = 'Git Stage Buffer' },
			{ "<leader>gR", ":Gitsigns reset_buffer<cr>",                                   desc = 'Git Reset Buffer' },
			{ "<leader>gp", ":Gitsigns preview_hunk<cr>",                                   desc = 'Git Preview Hunk' },
			{ "<leader>gB", function() require('gitsigns').blame_line({ full = true }) end, desc = 'Git Blame Line Full' },
			{ "<leader>gB", ":Gitsigns toggle_current_line_blame<cr>",                      desc = 'Git Toggle Blame Line' },
			{ "<leader>gd", ":Gitsigns diffthis<cr>",                                       desc = 'Git Diff This' },
			{ "<leader>gD", function() require("gitsigns").diffthis("~") end,               desc = 'Git Diff This' },
			{ "<leader>gt", ":Gitsigns toggle_deleted<cr>",                                 desc = 'Git Toggle Deleted' },
		}
	},
	{
		'Verf/deepwhite.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd [[colorscheme deepwhite]]
		end,
	}
}
