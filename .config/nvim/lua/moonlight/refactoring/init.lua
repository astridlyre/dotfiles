return function()
	local refactoring = require("refactoring").setup({
		prompt_func_return_type = { go = true },
		prompt_func_param_type = { go = true, cpp = true, c = true, java = true },
	})

	vim.api.nvim_set_keymap(
		"v",
		"<space>re",
		[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
		{ noremap = true, silent = true, expr = false }
	)
	vim.api.nvim_set_keymap(
		"v",
		"<space>rf",
		[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
		{ noremap = true, silent = true, expr = false }
	)
	vim.api.nvim_set_keymap(
		"v",
		"<space>rv",
		[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
		{ noremap = true, silent = true, expr = false }
	)
	vim.api.nvim_set_keymap(
		"v",
		"<space>ri",
		[[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
		{ noremap = true, silent = true, expr = false }
	)
end
