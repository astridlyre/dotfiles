return function()
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
