-- Install packer if not installed
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.api.nvim_exec(
	[[
  augroup Packer
    autocmd!
    autocmd BufWritePost config.lua PackerCompile
  augroup end
]],
	false
)

-- Load plugins
require("/user/plugins/coq")

local use = require("packer").use
require("packer").startup(function()
	use("wbthomason/packer.nvim")
	use("nvim-lua/plenary.nvim")

	-- Tree file explorer
	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
		config = require("/user/plugins/nvim-tree"),
	})

	use({ "lukas-reineke/indent-blankline.nvim", config = require("/user/plugins/indent-blankline") })
	use({ "echasnovski/mini.nvim", config = require("/user/plugins/mini") })
	use({ "norcalli/nvim-colorizer.lua", config = require("/user/plugins/colorizer") })

	-- Colorscheme
	use({
		"astridlyre/falcon",
		config = function()
			vim.cmd("colorscheme falcon")
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" }, { "kyazdani42/nvim-web-devicons", opt = true } },
		config = require("/user/plugins/telescope"),
	})

	use({ "akinsho/toggleterm.nvim", config = require("/user/plugins/toggleterm") })
	use({ "b3nj5m1n/kommentary", event = "BufEnter" })
	use({ "lewis6991/gitsigns.nvim", config = require("/user/plugins/gitsigns") })

	-- Treesitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", config = require("/user/plugins/treesitter") })
	use({ "nvim-treesitter/nvim-treesitter-textobjects" })
	use({ "windwp/nvim-ts-autotag" })

	-- Autocompletion
	use({
		"ms-jpq/coq_nvim",
		branch = "coq",
		run = ":COQdeps",
	})
	use({ "ms-jpq/coq.artifacts", branch = "artifacts" })
	use({ "neovim/nvim-lspconfig", config = require("/user/plugins/lsp").setup() })
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = require("/user/plugins/null-ls"),
	})

	use({
		"ray-x/lsp_signature.nvim",
		opt = true,
		event = "InsertCharPre",
		config = require("/user/plugins/lsp-signature"),
	})
	use({ "windwp/nvim-autopairs", event = "InsertCharPre", config = require("/user/plugins/autopairs") })

	-- Clojure plugins
	use({ "tpope/vim-dispatch", ft = { "clojure" } })
	use({ "clojure-vim/vim-jack-in", ft = { "clojure" } })
	use({ "Olical/conjure", ft = { "clojure" } })
	use({ "radenling/vim-dispatch-neovim", ft = { "clojure" } })
end)
