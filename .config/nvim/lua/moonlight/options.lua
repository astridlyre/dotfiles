local M = {}

M.setup = function()
	local remap = vim.api.nvim_set_keymap

	vim.g.coq_settings = {
		match = {
			exact_matches = 3,
			fuzzy_cutoff = 0.8,
			look_ahead = 1,
		},
		weights = {
			prefix_matches = 2.0,
			edit_distance = 1.5,
			recency = 0.75,
			proximity = 0.6,
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
				resolve_timeout = 0.09,
			},
			snippets = {
				enabled = true,
				weight_adjust = 1.5,
			},
		},
		auto_start = "shut-up",
		limits = {
			completion_auto_timeout = 0.17,
		},
	}

	-- COQ Remaps
	remap("i", "<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
	remap("i", "<c-c>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
end

return M
