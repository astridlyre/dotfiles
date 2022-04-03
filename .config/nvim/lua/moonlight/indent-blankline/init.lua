return function()
	vim.g.indent_blankline_filetype_exclude = {
		"help",
		"packer",
		"neo-tree",
		"starter",
	}
	require("indent_blankline").setup({
		space_char_blankline = " ",
		show_current_context = true,
	})
end
