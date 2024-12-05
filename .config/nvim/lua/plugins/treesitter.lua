return {
	{

		"windwp/nvim-ts-autotag",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = false, -- Auto close on trailing </
					filetypes = {
						"html",
						"javascript",
						"typescript",
						"javascriptreact",
						"typescriptreact",
						"svelte",
						"vue",
						"tsx",
						"jsx",
						"rescript",
						"xml",
						"php",
						"markdown",
						"glimmer",
						"handlebars",
						"hbs",
						"astro",
						"templ",
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", version = false },
			{ "windwp/nvim-ts-autotag",                      version = false },
			{ "andymass/vim-matchup",                        version = false },
			{ "nvim-treesitter/nvim-treesitter-textobjects", version = false },
		},
		build = ":TSUpdate",
		config = function()
			vim.treesitter.language.register("markdown", "octo")

			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				highlight = { enable = true, additional_vim_regex_highlighting = false },
				indent = { enable = false },
				incremental_selection = {
					enable = false,
					keymaps = {
						init_selection = true,
						node_incremental = "v",
						node_decremental = "<BS>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["ap"] = "@parameter.outer",
							["ip"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ia"] = "@attribute.inner",
							["aa"] = "@attribute.outer",
							["ic"] = "@conditional.inner",
							["ac"] = "@conditional.outer",
							["is"] = "@statement.inner",
							["as"] = "@statement.outer",
							["ib"] = "@block.inner",
							["ab"] = "@block.outer",
							["ir"] = "@regex.inner",
							["ar"] = "@regex.outer",
							["iC"] = "@call.inner",
							["aC"] = "@call.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = { ["<leader>sn"] = "@parameter.inner" },
						swap_previous = { ["<leader>sp"] = "@parameter.inner" },
					},
				},
				autopairs = { enable = true },
				matchup = { enable = true },
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]]"] = "@function.outer",
					},
					goto_next_end = {
						["]m"] = "@function.outer",
					},
					goto_previous_start = {
						["[["] = "@function.outer",
					},
					goto_previous_end = {
						["[m"] = "@function.outer",
					},
				},
			})
		end,
	},
}
