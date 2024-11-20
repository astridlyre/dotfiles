return {
	{ "folke/lazy.nvim",  version = "*" },
	{
		"ggandor/flit.nvim",
		version = false,
		config = function()
			require("flit").setup()
		end,
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()

			vim.keymap.set({ 'n', 'x', 'o' }, 'ga', function()
				require('leap.treesitter').select()
			end)

			-- Linewise.
			vim.keymap.set({ 'n', 'x', 'o' }, 'gA',
				'V<cmd>lua require("leap.treesitter").select()<cr>'
			)
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
