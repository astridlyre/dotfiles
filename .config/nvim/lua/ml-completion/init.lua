local completion = {}

function completion.coq()
	local remap = vim.api.nvim_set_keymap
	vim.g.coq_settings = {
		keymap = { recommended = false },
		display = { icons = { mode = "short" }, ghost_text = { enabled = false } },
		auto_start = "shut-up",
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
		doc_lines = 2,
		floating_window = true,
		hint_enable = true,
		hint_prefix = "❱ ",
		hint_scheme = "String",
		use_lspsaga = false,
		hi_parameter = "Search",
		max_height = 12,
		max_width = 120,
		handler_opts = { border = "single" },
		extra_trigger_chars = {},
	}
	require("lsp_signature").on_attach(cfg)
end

return completion
