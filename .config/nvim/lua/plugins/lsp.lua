return {
	{
		"neovim/nvim-lspconfig",
		version = false,
		config = function()
			require("moonlight.lsp").setup()
		end,
	},
	-- {
	-- 	'mrcjkb/haskell-tools.nvim',
	-- 	version = '^6', -- Recommended
	-- 	lazy = false, -- This plugin is already lazy
	-- },
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
		version = false,
		lazy = false,
		opts = {},
		keys = {
			{ "<leader>la", ":TSToolsAddMissingImports<cr>", desc = "Add Missing Imports" },
			{ "<leader>li", ":TSToolsOrganizeImports<cr>",   desc = "Organize Imports" },
		}
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end
	},
}
