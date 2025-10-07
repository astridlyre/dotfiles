return {
	{
		"ggandor/leap.nvim",
		commit = 'a755cea5ec06191b46702ac8fde8ef03ad2fbdeb',
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
	{
		"ggandor/flit.nvim",
		version = false,
		config = function()
			require("flit").setup()
		end,
		event = { "BufReadPost", "BufNewFile" },
	},
	-- {
	-- 	"guns/vim-sexp",
	-- 	version = false,
	-- 	ft = { "lisp", "scheme", "clojure", "racket", "fennel" },
	-- },
	-- {
	-- 	"tpope/vim-sexp-mappings-for-regular-people",
	-- 	version = false,
	-- 	ft = { "lisp", "scheme", "clojure", "racket", "fennel" },
	-- }
}
