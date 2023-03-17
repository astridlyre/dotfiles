return function()
	require("nvim-treesitter.configs").setup({
		playground = {
			enable = true,
			disable = {},
			updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			persist_queries = false, -- Whether the query persists across vim sessions
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
		ensure_installed = "all",
		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = false,
			keymaps = {
				init_selection = "<CR>",
				scope_incremental = "<S-CR>",
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
