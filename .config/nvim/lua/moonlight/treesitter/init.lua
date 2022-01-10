return function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = "maintained",
		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<CR>",
				scope_incremental = "<CR>",
				node_incremental = "<TAB>",
				node_decremental = "<S-TAB>",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["ap"] = "@parameter.outer",
					["ip"] = "@parameter.inner",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			swap = {
				enable = true,
				swap_next = { ["<leader>sn"] = "@parameter.inner" },
				swap_previous = { ["<leader>sp"] = "@parameter.inner" },
			},
		},
		autotag = { enable = true },
		autopairs = { enable = true },
		matchup = {
			enable = true,
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	})
end
