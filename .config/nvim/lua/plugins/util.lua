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
		'echasnovski/mini.nvim',
		version = false,
		config = function()
			local hipatterns = require('mini.hipatterns')
			hipatterns.setup({
				highlighters = {
					-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
					fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
					hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
					todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
					note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

					-- Highlight hex color strings (`#rrggbb`) using that color
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
		end
	},
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
