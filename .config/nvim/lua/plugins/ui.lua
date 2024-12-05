return {
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

			local utils = require("moonlight.utils")
			local lmap = utils.lmap
			local nmap = utils.nmap
			local vmap = utils.vmap

			-- Navigation
			nmap("]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<cr>'", { expr = true })
			nmap("[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<cr>'", { expr = true })

			-- Actions
			vmap("<space>hs", ":Gitsigns stage_hunk<cr>")
			vmap("<space>hr", ":Gitsigns reset_hunk<cr>")
			lmap("hs", ":Gitsigns stage_hunk<cr>")
			lmap("hr", ":Gitsigns reset_hunk<cr>")
			lmap("hS", gitsigns.stage_buffer)
			lmap("hu", gitsigns.undo_stage_hunk)
			lmap("hR", gitsigns.reset_buffer)
			lmap("hp", gitsigns.preview_hunk)
			lmap("hb", function()
				gitsigns.blame_line({ full = true })
			end)
			lmap("gb", gitsigns.toggle_current_line_blame)
			lmap("hd", gitsigns.diffthis)
			lmap("hD", function()
				gitsigns.diffthis("~")
			end)
			lmap("gt", gitsigns.toggle_deleted)
		end,
	},
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
	{
		"savq/melange-nvim",
		config = function()
			vim.opt.termguicolors = true
			vim.cmd.colorscheme("melange")
		end
	}
}
