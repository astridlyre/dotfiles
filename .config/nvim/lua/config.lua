local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd("packadd packer.nvim")
end

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	use({
		"ms-jpq/coq_nvim",
		branch = "coq",
		config = function()
			require("ml-completion").coq()
		end,
	})
	use({ "ms-jpq/coq.artifacts", branch = "artifacts" })

	use({
		"astridlyre/falcon",
		config = function()
			vim.cmd("colorscheme falcon")
		end,
	})
	use({
		"shadmansaleh/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("ml-ui").lualine()
		end,
	})
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("ml-ui").colorizer()
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" }, { "kyazdani42/nvim-web-devicons", opt = true } },
	})
	use("junegunn/vim-easy-align")
	use("b3nj5m1n/kommentary")
	use("tpope/vim-fugitive")
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		event = { "BufRead", "BufNewFile" },
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("ml-treesitter").configure()
		end,
		run = ":TSUpdate",
	})
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
	})
	use({ "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" })
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" })

	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp").configure()
		end,
	})
	use({
		"ray-x/lsp_signature.nvim",
		config = function()
			require("ml-completion").lsp_signature()
		end,
	})
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("ml-completion").autopairs()
		end,
	})
end)
