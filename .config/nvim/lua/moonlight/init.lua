local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("moonlight.options")

require("lazy").setup({
	{ "folke/lazy.nvim", version = "*" },
	{
		"norcalli/nvim-colorizer.lua",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("colorizer").setup({
				"css",
				"javascript",
				"html",
				"yaml",
				"python",
				"sass",
				"markdown",
				"lua",
				"typescript",
				"vim",
				"sh",
				"bash",
				"scss",
				"kitty",
				"javascriptreact",
				"typescriptreact",
				"dosini",
			})
		end,
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
		"echasnovski/mini.statusline",
		version = false,
		config = function()
			require("mini.statusline").setup({
				set_vim_settings = false,
			})
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
	{
		dir = "~/projects/lunabones",
		dependencies = { "rktjmp/lush.nvim", version = false },
		version = false,
		dev = true,
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme lunabones")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", version = false },
			{ "windwp/nvim-ts-autotag", version = false },
			{ "andymass/vim-matchup", version = false },
			{ "nvim-treesitter/nvim-treesitter-textobjects", version = false },
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = false,
					keymaps = {
						init_selection = "<CR>",
						scope_incremental = "<S-CR>",
						node_incremental = "<TAB>",
						node_decremental = "<S-TAB>",
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
				autotag = { enable = true },
				autopairs = { enable = true },
				matchup = {
					enable = true,
				},
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
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				enable_check_bracket_line = false,
			})

			local rule = require("nvim-autopairs").get_rule("'")[1]
			local cond = require("nvim-autopairs.conds")

			-- remove add single quote on filetype scheme or lisp
			rule.not_filetypes = { "scheme", "lisp", "clojure", "clj" }
			rule:with_pair(cond.not_after_text("["))
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp", version = false },
			{ "hrsh7th/cmp-nvim-lua", version = false },
			{ "hrsh7th/cmp-buffer", version = false },
			{ "saadparwaiz1/cmp_luasnip", version = false },
			{ "L3MON4D3/LuaSnip", build = "make install_jsregexp", version = false },
			{ dir = "~/projects/friendly-snippets", dev = true },
			{ "onsails/lspkind-nvim", version = false },
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")
			local utils = require("moonlight.utils")
			local imap = utils.imap

			-- load snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			-- snippet jumping
			local t = function(str)
				return vim.api.nvim_replace_termcodes(str, true, true, true)
			end

			local function snippet_next()
				if luasnip and luasnip.expand_or_jumpable() then
					return luasnip.expand_or_jump()
				else
					return t("<C-j>")
				end
			end

			local function snippet_prev()
				if luasnip and luasnip.jumpable(-1) then
					return luasnip.jump(-1)
				else
					return t("<C-k>")
				end
			end

			local function expand(args)
				luasnip.lsp_expand(args.body)
			end

			imap("<C-e>", "<C-k>")
			imap("<C-j>", snippet_next)
			imap("<C-k>", snippet_prev)

			-- source configs
			local source_mapping = {
				nvim_lsp = "[lsp]",
				nvim_lua = "[lua]",
				buffer = "[buf]",
			}

			local sources = cmp.config.sources({
				{ name = "luasnip" },
				{ name = "copilot", group_index = 2 },
				{ name = "nvim_lsp" },
				-- { name = "conjure" },
				{ name = "nvim_lua" },
				{ name = "buffer" },
			})

			local format = lspkind.cmp_format({
				mode = "symbol",
				maxwidth = 50,
				before = function(entry, vim_item)
					vim_item.menu = source_mapping[entry.source.name]
					return vim_item
				end,
				symbol_map = { Copilot = "" },
			})

			local compare = require("cmp.config.compare")

			-- setup cmp
			cmp.setup({
				debug = false,
				snippet = { expand = expand },
				experimental = { ghost_text = true },
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-e>"] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					["<c-y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
				}),
				sources = sources,
				formatting = { format = format },
				sorting = {
					priority_weight = 2,
					comparators = {
						require("copilot_cmp.comparators").prioritize,
						require("copilot_cmp.comparators").score,
						compare.offset,
						compare.exact,
						compare.score,
						compare.kind,
						compare.sort_text,
						compare.length,
						compare.order,
					},
				},
				window = {
					completion = { border = "solid" },
					documentation = { border = "solid" },
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		version = false,
		config = function()
			require("moonlight.lsp").setup()
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		version = false,
		dependencies = { "nvim-lspconfig" },
		config = function()
			local lsp = require("moonlight.lsp")
			local capabilities = lsp.make_capabilities()
			local flags = lsp.flags

			-- Null LS
			local null_ls = require("null-ls")
			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics

			null_ls.setup({
				sources = {
					formatting.joker.with({ filetypes = { "clojure", "clj" } }),
					formatting.prettierd,
					formatting.shfmt,
					formatting.black,
					formatting.fixjson,
					formatting.goimports,
					formatting.isort,
					formatting.stylua,
					diagnostics.clj_kondo,
					diagnostics.shellcheck,
					diagnostics.staticcheck,
					diagnostics.write_good.with({ filetypes = { "markdown", "tex", "text" } }),
					diagnostics.flake8,
					diagnostics.vint,
					diagnostics.yamllint,
					diagnostics.stylelint,
					require("typescript.extensions.null-ls.code-actions"),
				},
				capabilities = capabilities,
				flags = flags,
				on_attach = function(client)
					if client.server_capabilities.documentFormattingProvider then
						vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
				autocmd BufWritePre <buffer> lua require('moonlight.autoformat').format()
            augroup END
            ]])
					end
				end,
			})
		end,
	},
	{ "jose-elias-alvarez/typescript.nvim", lazy = true, version = false },
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufRead", "BufNewFile" },
		version = false,
		config = function()
			local gitsigns = require("gitsigns")

			gitsigns.setup({
				signs = {
					add = { hl = "GitGutterAdd", text = "▎" },
					change = { hl = "GitGutterChange", text = "▎" },
					delete = { hl = "GitGutterDelete", text = "" },
					topdelete = { hl = "GitGutterDelete", text = "" },
					changedelete = { hl = "GitGutterChange", text = "▎" },
					untracked = { text = "▎" },
				},
			})

			local utils = require("moonlight.utils")
			local lmap = utils.lmap
			local nmap = utils.nmap
			local vmap = utils.vmap

			-- Navigation
			nmap("]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<cr>'", { expr = true })
			nmap("[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<cr>'", { expr = true })

			-- Actions
			vmap("<space>hs", ":Gitsigns stage_hunk<cr>")
			vmap("<space>hr", ":Gitsigns reset_hunk<cr>")
			lmap("hs", ":Gitsigns stage_hunk<cr>")
			lmap("hr", ":Gitsigns reset_hunk<cr>")
			lmap("hS", gitsigns.stage_buffer)
			lmap("hu", gitsigns.undo_stage_hunk)
			lmap("hR", gitsigns.reset_buffer)
			lmap("hp", gitsigns.preview_hunk)
			lmap("hb", function()
				gitsigns.blame_line({ full = true })
			end)
			lmap("gb", gitsigns.toggle_current_line_blame)
			lmap("hd", gitsigns.diffthis)
			lmap("hD", function()
				gitsigns.diffthis("~")
			end)
			lmap("gt", gitsigns.toggle_deleted)
		end,
	},
	{ "nvim-lua/plenary.nvim", lazy = true, version = false },
	{ "kyazdani42/nvim-web-devicons", lazy = true, version = false },
	{ "MunifTanjim/nui.nvim", lazy = true, version = false },
	{ "nvim-telescope/telescope-ui-select.nvim", version = false },
	{ "nvim-telescope/telescope-symbols.nvim", version = false },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", version = false },
	{
		"nvim-telescope/telescope.nvim",
		version = false,
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					prompt_prefix = "❯ ",
					selection_caret = "  ",
					path_display = { "smart" },
					sorting_strategy = "ascending",
					layout_strategy = "flex",
					layout_config = {
						horizontal = { prompt_position = "top", preview_width = 0.55 },
						vertical = { mirror = false },
						width = 0.87,
						height = 0.8,
						preview_cutoff = 120,
					},
					dynamic_preview_title = true,
					preview = {
						filesize_hook = function(filepath, bufnr, opts)
							local max_bytes = 10000
							local cmd = { "head", "-c", max_bytes, filepath }
							require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
						end,
					},
				},
				pickers = {
					find_files = {
						find_command = {
							"rg",
							"--files",
							"--hidden",
							"--glob",
							"!**/node_modules/**",
							"--glob",
							"!**/build/**",
							"--glob",
							"!**/.git/**",
							"--glob",
							"!**/.cache/**",
							"--glob",
							"!**/.mypy_cache/**",
							"--glob",
							"!**/dist/**",
							"--glob",
							"!**/.parcel-cache/**",
							"--glob",
							"!*.min.js",
							"--max-filesize",
							"1M",
							"--glob",
							"!*.{jpg,png,gif}",
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		version = false,
		config = function()
			vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
			vim.cmd([[
highlight! link NeoTreeDirectoryIcon NvimTreeFolderIcon
highlight! link NeoTreeDirectoryName NvimTreeFolderName
highlight! link NeoTreeSymbolicLinkTarget NvimTreeSymlink
highlight! link NeoTreeRootName NvimTreeRootFolder
highlight! link NeoTreeDirectoryName NvimTreeOpenedFolderName
highlight! link NeoTreeFileNameOpened NvimTreeOpenedFile
]])

			require("neo-tree").setup({
				close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
				popup_border_style = "solid",
				resize_timer_interval = -1,
				enable_git_status = true,
				enable_diagnostics = false,
				default_component_configs = {
					indent = {
						indent_size = 2,
						padding = 1, -- extra padding on left hand side
						-- indent guides
						with_markers = true,
						indent_marker = "│",
						last_indent_marker = "└",
						highlight = "NeoTreeIndentMarker",
						-- expander config, needed for nesting files
						with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
						expander_collapsed = "",
						expander_expanded = "",
						expander_highlight = "NeoTreeExpander",
					},
					icon = {
						folder_closed = "",
						folder_open = "",
						folder_empty = "ﰊ",
						default = "*",
					},
					modified = {
						symbol = "⏺",
						highlight = "NeoTreeModified",
					},
					name = {
						trailing_slash = false,
						use_git_status_colors = true,
					},
					git_status = {
						symbols = {
							-- Change type
							added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
							modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
							deleted = "✖", -- this can only be used in the git_status source
							renamed = "", -- this can only be used in the git_status source
							-- Status type
							untracked = "",
							ignored = "",
							unstaged = "",
							staged = "",
							conflict = "",
						},
					},
				},
				window = {
					position = "left",
					width = 30,
					mappings = {
						["<space>"] = "toggle_node",
						["<2-LeftMouse>"] = "open",
						["<cr>"] = "open",
						["S"] = "open_split",
						["s"] = "open_vsplit",
						["t"] = "open_tabnew",
						["C"] = "close_node",
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["H"] = "toggle_hidden",
						["R"] = "refresh",
						["a"] = "add",
						["A"] = "add_directory",
						["d"] = "delete",
						["r"] = "rename",
						["y"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["c"] = "copy", -- takes text input for destination
						["m"] = "move", -- takes text input for destination
						["q"] = "close_window",
					},
				},
				nesting_rules = {},
				filesystem = {
					filtered_items = {
						visible = false, -- when true, they will just be displayed differently than normal items
						hide_dotfiles = true,
						hide_gitignored = true,
						hide_by_name = {
							".DS_Store",
							"thumbs.db",
							"node_modules",
						},
					},
					follow_current_file = true, -- This will find and focus the file in the active buffer every
					hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
					use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
				},
				git_status = {
					window = {
						position = "float",
						mappings = {
							["A"] = "git_add_all",
							["gu"] = "git_unstage_file",
							["ga"] = "git_add_file",
							["gr"] = "git_revert_file",
							["gc"] = "git_commit",
							["gp"] = "git_push",
							["gg"] = "git_commit_and_push",
						},
					},
				},
			})
		end,
	},
	{
		"ggandor/flit.nvim",
		config = function()
			require("flit").setup()
		end,
	},
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()
		end,
		version = false,
		event = { "BufReadPost", "BufNewFile" },
	},
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{ "nanotee/sqls.nvim", version = false },
	{
		"zbirenbaum/copilot.lua",
		version = false,
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",
		config = function()
			local copilot = require("copilot")
			local panel = require("copilot.panel")
			local suggestion = require("copilot.suggestion")
			local utils = require("moonlight.utils")
			local lmap = utils.lmap

			copilot.setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
				server_opts_overrides = {
					trace = "verbose",
					settings = {
						advanced = {
							inlineSuggestCount = 3, -- #completions for getCompletions
						},
					},
				},
			})

			lmap("csa", function()
				suggestion.accept()
			end)

			lmap("csn", function()
				suggestion.next()
			end)

			lmap("csp", function()
				suggestion.prev()
			end)

			lmap("cpa", function()
				panel.accept()
			end)

			lmap("cpn", function()
				panel.next()
			end)

			lmap("cpp", function()
				panel.prev()
			end)

			lmap("cpo", function()
				panel.open()
			end)

			lmap("cpr", function()
				panel.refresh()
			end)
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		version = false,
		config = function()
			require("copilot_cmp").setup({
				method = "getCompletionsCycling",
			})
		end,
	},
	{
		"Olical/conjure",
		version = false,
		filetypes = { "clojure", "fennel", "lisp", "scheme", "hy", "clj" },
	},
})
