return function()
	-- Gitsigns
	local gitsigns = require("gitsigns")

	gitsigns.setup({
		signs = {
			add = { hl = "GitGutterAdd", text = "+" },
			change = { hl = "GitGutterChange", text = "~" },
			delete = { hl = "GitGutterDelete", text = "_" },
			topdelete = { hl = "GitGutterDelete", text = "‾" },
			changedelete = { hl = "GitGutterChange", text = "~" },
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
end
