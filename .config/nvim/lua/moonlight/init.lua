-- Personal Configuration
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local compile_path = fn.stdpath("config") .. "/lua/packer_compiled.lua"

if fn.empty(vim.fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	execute("packadd packer.nvim")
end

-- Handle errors
local require_plugin = function(p)
	local ok, plugin = pcall(require, p)
	if ok then
		return plugin
	else
		print("Unable to load " .. p)
		return nil
	end
end

-- Packer Configuration
local packer = require_plugin("packer")
local util = require_plugin("packer.util")
local packer_init = {
	display = {
		open_fn = function()
			if util ~= nil then
				return util.float({ border = "rounded" })
			end
		end,
	},
}

if packer ~= nil then
	packer.init(packer_init)
end

require("moonlight.options")
require("moonlight.functions")
require("moonlight.autocmds")

return packer.startup({
	function(use)
		use({ "lewis6991/impatient.nvim" })
		use({ "wbthomason/packer.nvim" })

		-- UI Plugins
		use({ "norcalli/nvim-colorizer.lua", config = require("moonlight.colorizer"), event = "BufRead" })
		use({ "echasnovski/mini.nvim", config = require("moonlight.mini"), event = "BufWinEnter" })
		use({
			"shaunsingh/oxocarbon.nvim",
			run = "./install.sh",
			config = function()
				vim.cmd("colorscheme oxocarbon")
			end,
		})

		-- Treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = require("moonlight.treesitter"),
		})
		use({ "nvim-treesitter/nvim-treesitter-textobjects" })
		use({ "windwp/nvim-ts-autotag" })
		use({ "andymass/vim-matchup" })

		-- Completion
		use({
			"hrsh7th/nvim-cmp",
			config = require("moonlight.cmp"),
			requires = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-buffer",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
				"astridlyre/friendly-snippets",
				"onsails/lspkind-nvim",
				--"tami5/compe-conjure",
			},
		})

		-- Language Server
		use({ "b0o/schemastore.nvim" })
		use({
			"neovim/nvim-lspconfig",
			config = function()
				require("moonlight.lsp").setup()
			end,
		})
		use({
			"jose-elias-alvarez/null-ls.nvim",
			config = require("moonlight.null-ls"),
			after = "nvim-lspconfig",
		})
		use({ "windwp/nvim-autopairs", event = "InsertEnter", config = require("moonlight.autopairs") })
		--use({ "nanotee/sqls.nvim" })
		use({
			"ThePrimeagen/refactoring.nvim",
			requires = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-treesitter/nvim-treesitter" },
			},
			config = require("moonlight.refactoring"),
		})

		-- Version Control
		use({
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = require("moonlight.gitsigns"),
			event = "BufRead",
		})

		-- Terminal
		use({ "akinsho/toggleterm.nvim", config = require("moonlight.toggleterm") })

		-- Navigation
		use({
			"nvim-telescope/telescope.nvim",
			requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons" },
			config = require("moonlight.telescope"),
			cmd = "Telescope",
		})
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
		use({
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v2.x",
			requires = {
				"nvim-lua/plenary.nvim",
				"kyazdani42/nvim-web-devicons",
				"MunifTanjim/nui.nvim",
			},
			config = require("moonlight.neo-tree"),
			cmd = "Neotree",
		})
		use({ "ggandor/leap.nvim", config = require("moonlight.leap"), event = "BufEnter" })

		-- Misc
		use({ "b3nj5m1n/kommentary", event = "BufEnter" })
		use({ "tpope/vim-repeat", event = "BufEnter" })

		-- Clojure plugins
		--[[ use({ "tpope/vim-dispatch", ft = { "clojure", "clojurescript", "fennel", "racket", "scheme" } })
		use({ "clojure-vim/vim-jack-in", ft = { "clojure", "clojurescript", "fennel", "racket", "scheme" } })
		use({ "Olical/conjure", branch = "develop", ft = { "clojure", "clojurescript", "fennel", "racket", "scheme" } })
		use({ "radenling/vim-dispatch-neovim", ft = { "clojure", "clojurescript", "fennel", "racket", "scheme" } })
		use({ "wlangstroth/vim-racket" })
		use({ "Olical/aniseed", branch = "develop", ft = { "fennel" } }) ]]
	end,
	config = { compile_path = compile_path },
})
