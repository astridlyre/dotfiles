local ts = {}

-- Treesitter
function ts.configure()
	require("nvim-treesitter.configs").setup({
		ensure_installed = "maintained",
		highlight = { enable = true },
		-- indent = {enable = true},
		textsubjects = { enable = true, keymaps = { ["."] = "textsubjects-smart" } },
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
				swap_next = { ["<leader>a"] = "@parameter.inner" },
				swap_previous = { ["<leader>A"] = "@parameter.inner" },
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
end

return ts
