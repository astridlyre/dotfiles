local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
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
local packer_init = {
	display = {
		open_fn = function()
			return require_plugin("packer.util").float({ border = "single" })
		end,
	},
}

packer.init(packer_init)

-- Load global vim options
require("moonlight.options").setup()

return packer.startup({
	function(use)
		use({ "lewis6991/impatient.nvim" })
		use({ "wbthomason/packer.nvim" })

		-- UI Plugins
		use({ "norcalli/nvim-colorizer.lua", config = require("moonlight.colorizer"), event = "BufRead" })
		use({ "echasnovski/mini.nvim", config = require("moonlight.mini"), event = "BufWinEnter" })
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = require("moonlight.indent-blankline"),
			event = "BufRead",
		})
		use({
			"astridlyre/substrata.nvim",
			config = function()
				vim.cmd("colorscheme substrata")
			end,
		})

		-- Treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = require("moonlight.treesitter"),
		})
		use({ "nvim-treesitter/nvim-treesitter-textobjects", event = "InsertCharPre" })
		use({ "windwp/nvim-ts-autotag", event = "InsertCharPre" })
		use({ "andymass/vim-matchup" })

		-- Language Server and Completion
		use({
			"ms-jpq/coq_nvim",
			branch = "coq",
			run = ":COQdeps",
		})
		use({ "ms-jpq/coq.artifacts", branch = "artifacts" })
		use({ "b0o/schemastore.nvim" })
		use({ "ray-x/lsp_signature.nvim" })
		use({
			"neovim/nvim-lspconfig",
			config = function()
				require("moonlight.lsp").setup()
			end,
			after = "lsp_signature.nvim",
		})
		use({
			"jose-elias-alvarez/null-ls.nvim",
			config = require("moonlight.null-ls"),
			after = "nvim-lspconfig",
		})
		use({ "windwp/nvim-autopairs", event = "InsertCharPre", config = require("moonlight.autopairs") })

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
		use({
			"kyazdani42/nvim-tree.lua",
			requires = { "kyazdani42/nvim-web-devicons" },
			config = require("moonlight.nvim-tree"),
			cmd = "NvimTreeToggle",
		})
		use({
			"ggandor/lightspeed.nvim",
			event = "BufEnter",
		})

		-- Misc
		use({ "b3nj5m1n/kommentary", event = "BufEnter" })
		use({ "tpope/vim-repeat", event = "BufEnter" })

		-- Clojure plugins
		use({ "tpope/vim-dispatch", ft = { "clojure", "clojurescript", "fennel" } })
		use({ "clojure-vim/vim-jack-in", ft = { "clojure", "clojurescript", "fennel" } })
		use({ "Olical/conjure", ft = { "clojure", "clojurescript", "fennel" } })
		use({ "radenling/vim-dispatch-neovim", ft = { "clojure", "clojurescript", "fennel" } })
	end,
	{ config = {
		compile_path = compile_path,
	} },
})
