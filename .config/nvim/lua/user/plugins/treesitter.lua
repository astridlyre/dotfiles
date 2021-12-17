return function()
	local remap = vim.api.nvim_set_keymap

	require("nvim-treesitter.configs").setup({
		ensure_installed = "maintained",
		highlight = { enable = true },
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
			enable = true, -- mandatory, false will disable the whole extension
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

	vim.g.coq_settings = {
		match = {
			exact_matches = 3,
			fuzzy_cutoff = 0.7,
			look_ahead = 1,
		},
		weights = {
			prefix_matches = 2.0,
			edit_distance = 1.0,
			recency = 0.75,
			proximity = 1.0,
		},
		keymap = { recommended = false },
		display = {
			icons = { mode = "short" },
			ghost_text = { enabled = false },
			preview = { positions = {
				north = 4,
				south = 3,
				east = 1,
				west = 2,
			} },
		},
		clients = {
			buffers = {
				same_filetype = true,
				enabled = true,
				weight_adjust = -1.5,
			},
			tree_sitter = {
				enabled = true,
				weight_adjust = 0.6,
			},
			lsp = {
				enabled = true,
				weight_adjust = 2.0,
				resolve_timeout = 0.08,
			},
			snippets = {
				enabled = true,
				weight_adjust = 1.5,
			},
		},
		auto_start = "shut-up",
		limits = {
			completion_auto_timeout = 0.2,
		},
	}
	remap("i", "<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
	remap("i", "<c-c>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
end
