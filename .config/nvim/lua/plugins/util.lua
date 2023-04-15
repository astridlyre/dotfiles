return {
	{ "folke/lazy.nvim", version = "*" },
	{
		"ggandor/flit.nvim",
		config = function()
			require("flit").setup()
		end,
	},
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()
		end,
		version = false,
		event = { "BufReadPost", "BufNewFile" },
	},
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		version = false,
		config = function()
			require("mini.comment").setup()
		end,
	},
	{
		"echasnovski/mini.bufremove",
		event = "VeryLazy",
		version = false,
		config = function()
			require("mini.bufremove").setup()
		end,
	},
}
