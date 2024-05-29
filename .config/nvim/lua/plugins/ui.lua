return {
	{
		"sainnhe/gruvbox-material",
		name = "gruvbox",
		version = false,
		config = function()
			vim.g.gruvbox_material_foreground = "material"
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_better_performance = 1
			vim.cmd("colorscheme gruvbox-material")
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("colorizer").setup({
				"css",
				"javascript",
				"html",
				"yaml",
				"python",
				"sass",
				"markdown",
				"lua",
				"typescript",
				"vim",
				"sh",
				"bash",
				"scss",
				"kitty",
				"javascriptreact",
				"typescriptreact",
				"dosini",
			})
		end,
	},
	{
		"Olical/conjure",
		version = false,
		lazy = true,
		filetypes = { "clojure", "fennel", "lisp", "scheme", "hy", "clj" },
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufRead", "BufNewFile" },
		version = false,
		config = function()
			local gitsigns = require("gitsigns")

			gitsigns.setup({
				signs = {
					add = { hl = "GitGutterAdd", text = "▎" },
					change = { hl = "GitGutterChange", text = "▎" },
					delete = { hl = "GitGutterDelete", text = "" },
					topdelete = { hl = "GitGutterDelete", text = "" },
					changedelete = { hl = "GitGutterChange", text = "▎" },
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
		"pwntester/octo.nvim",
		lazy = true,
		cmd = "Octo",
		version = false,
		config = function()
			require("octo").setup()
		end,
	},
	{
		"echasnovski/mini.statusline",
		version = false,
		config = function()
			require("mini.statusline").setup({
				set_vim_settings = false,
			})
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
}
