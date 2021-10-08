local completion = {}

function completion.coq()
	local remap = vim.api.nvim_set_keymap
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

	-- these mappings are coq recommended mappings unrelated to nvim-autopairs
	remap("i", "<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
	remap("i", "<c-c>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
end

-- autopairs
function completion.autopairs()
	local remap = vim.api.nvim_set_keymap
	local npairs = require("nvim-autopairs")

	npairs.setup({ map_bs = false })
	_G.MUtils = {}

	MUtils.CR = function()
		if vim.fn.pumvisible() ~= 0 then
			return npairs.esc("<c-e>") .. npairs.autopairs_cr()
		else
			return npairs.autopairs_cr()
		end
	end
	remap("i", "<cr>", "v:lua.MUtils.CR()", { expr = true, noremap = true })

	MUtils.BS = function()
		if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
			return npairs.esc("<c-e>") .. npairs.autopairs_bs()
		else
			return npairs.autopairs_bs()
		end
	end
	remap("i", "<bs>", "v:lua.MUtils.BS()", { expr = true, noremap = true })
end

-- Function signatures as you type
function completion.lsp_signature()
	local cfg = {
		bind = true,
		doc_lines = 0,
		floating_window = true,
		floating_window_above_cur_line = true,
		hint_enable = true,
		hint_prefix = "❱ ",
		hint_scheme = "String",
		use_lspsaga = false,
		hi_parameter = "Search",
		max_height = 4,
		max_width = 120,
		handler_opts = { border = "single" },
		extra_trigger_chars = {},
	}
	require("lsp_signature").on_attach(cfg)
end

return completion
