return {
	{ "tpope/vim-dadbod", version = false, lazy = true },
	{ "kristijanhusak/vim-dadbod-completion", version = false, lazy = true },
	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = "DBUI",
		lazy = true,
		version = false,
		dependencies = {
			"vim-dadbod",
			"kristijanhusak/vim-dadbod-completion",
		},
	},
}
