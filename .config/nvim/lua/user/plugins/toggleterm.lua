return function()
	require("toggleterm").setup({
		size = 15,
		open_mapping = [[<C-\>]],
		hide_numbers = true,
		shade_filetypes = {},
		shade_terminals = true,
		shading_factor = 1,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true,
		shell = vim.o.shell,
		float_opts = {
			border = "curved",
			winblend = 3,
			highlights = {
				border = "Normal",
				background = "Normal",
			},
		},
	})
	function _G.set_terminal_keymaps()
		local opts = { noremap = true }
		vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-w>h", [[<C-\><C-n><C-W>h]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-w>j", [[<C-\><C-n><C-W>j]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-w>k", [[<C-\><C-n><C-W>k]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-w>l", [[<C-\><C-n><C-W>l]], opts)
	end
	vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
end
