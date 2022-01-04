return function()
	local remap = vim.api.nvim_set_keymap
	local npairs = require("nvim-autopairs")
	npairs.setup({ map_bs = false, enable_check_bracket_line = false, ignored_next_char = "[%w%.]", map_cr = false })

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
