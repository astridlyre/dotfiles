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

	local function map(from, to)
		vim.api.nvim_buf_set_keymap(0, "t", from, to, { noremap = true })
	end

	function _G.set_terminal_keymaps()
		map("<esc>", [[<C-\><C-n>]])
		map("<C-w>h", [[<C-\><C-n><C-W>h]])
		map("<C-w>j", [[<C-\><C-n><C-W>j]])
		map("<C-w>k", [[<C-\><C-n><C-W>k]])
		map("<C-w>l", [[<C-\><C-n><C-W>l]])
	end
	vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
end
