return {
	{
		"neovim/nvim-lspconfig",
		version = false,
		config = function()
			require("moonlight.lsp").setup()
		end,
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end
	},
}
