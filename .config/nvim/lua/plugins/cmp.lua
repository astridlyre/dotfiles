return {
	{
		"iguanacucumber/magazine.nvim",
		name = "nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp",               version = false },
			{ "hrsh7th/cmp-nvim-lua",               version = false },
			{ "hrsh7th/cmp-buffer",                 version = false },
			{ "saadparwaiz1/cmp_luasnip",           version = false },
			{ "L3MON4D3/LuaSnip",                   build = "make install_jsregexp", version = false },
			{ dir = "~/projects/friendly-snippets", dev = true },
			{ "onsails/lspkind-nvim" },
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")
			local utils = require("moonlight.utils")
			local imap = utils.imap

			luasnip.config.set_config({ region_check_events = "CursorMoved" })

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

			local autocomplete_group = vim.api.nvim_create_augroup("vimrc_autocompletion", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					cmp.setup.buffer({
						sources = {
							{ name = "copilot", group_index = 2 },
						},
					})
				end,
				group = autocomplete_group,
			})

			local sources = cmp.config.sources({
				{ name = "luasnip",  group_index = 2 },
				{ name = "copilot",  group_index = 2 },
				{ name = "nvim_lsp", group_index = 2 },
				-- { name = "conjure" },
				{ name = "nvim_lua", group_index = 2 },
			}, {
				{ name = "buffer", group_index = 2 },
			})

			local format = lspkind.cmp_format({
				mode = "symbol", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
				menu = {
					buffer = "[Buffer]",
					nvim_lsp = "[LSP]",
					vsnip = "[Snippet]",
					tags = "[Tag]",
					path = "[Path]",
				},
				before = function(entry, vim_item)
					vim_item.menu = "(" .. vim_item.kind .. ")"
					vim_item.dup = ({
						nvim_lsp = 0,
						path = 0,
					})[entry.source.name] or 0
					return vim_item
				end,
				symbol_map = { Copilot = "" },
			})

			local compare = require("cmp.config.compare")

			-- setup cmp
			cmp.setup({
				debug = false,
				snippet = { expand = expand },
				experimental = { ghost_text = { hl_group = "LspCodeLens" } },
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-e>"] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close({ behavior = cmp.ConfirmBehavior.Replace }),
					}),
					["<c-y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
				}),
				sources = sources,
				formatting = {
					format = format,
					fields = { "kind", "abbr", "menu" },
				},
				sorting = {
					priority_weight = 2,
					comparators = {
						compare.exact,
						require("copilot_cmp.comparators").prioritize,
						-- require("copilot_cmp.comparators").score,
						compare.offset,
						compare.score,
						compare.kind,
						compare.sort_text,
						compare.length,
						compare.order,
					},
				},
				window = {
					completion = cmp.config.window.bordered({
						col_offset = 3,
						side_padding = 0,
						winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
					}),
					documentation = cmp.config.window.bordered({
						winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
					}),
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
		end,
	},
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
							inlineSuggestCount = 5, -- #completions for getCompletions
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
	-- {
	-- 	'saghen/blink.cmp',
	-- 	lazy = false, -- lazy loading handled internally
	-- 	-- optional: provides snippets for the snippet source
	-- 	dependencies = {
	-- 		{ dir = "~/projects/friendly-snippets", dev = true },
	-- 		{ "giuxtaposition/blink-cmp-copilot" }
	-- 	},
	--
	-- 	-- use a release tag to download pre-built binaries
	-- 	version = 'v0.*',
	-- 	-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- 	-- build = 'cargo build --release',
	-- 	-- If you use nix, you can build from source using latest nightly rust with:
	-- 	-- build = 'nix run .#build-plugin',
	--
	-- 	---@module 'blink.cmp'
	-- 	---@type blink.cmp.Config
	-- 	opts = {
	-- 		-- 'default' for mappings similar to built-in completion
	-- 		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
	-- 		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
	-- 		-- see the "default configuration" section below for full documentation on how to define
	-- 		-- your own keymap.
	-- 		keymap = { preset = 'default', ['<C-j>'] = { 'snippet_forward', 'fallback' }, ['<C-k>'] = { 'snippet_backward', 'fallback' } },
	--
	-- 		highlight = {
	-- 			-- sets the fallback highlight groups to nvim-cmp's highlight groups
	-- 			-- useful for when your theme doesn't support blink.cmp
	-- 			-- will be removed in a future release, assuming themes add support
	-- 			use_nvim_cmp_as_default = true,
	-- 		},
	-- 		-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
	-- 		-- adjusts spacing to ensure icons are aligned
	-- 		nerd_font_variant = 'mono',
	--
	-- 		-- experimental auto-brackets support
	-- 		-- accept = { auto_brackets = { enabled = true } }
	--
	-- 		-- experimental signature help support
	-- 		-- trigger = { signature_help = { enabled = true } }
	-- 		sources = {
	-- 			providers = {
	-- 				copilot = {
	-- 					name = "copilot",
	-- 					module = "blink-cmp-copilot",
	-- 				},
	-- 			},
	-- 			completion = {
	-- 				enabled_providers = { "lsp", "path", "snippets", "buffer", "copilot" },
	-- 			},
	-- 		},
	-- 	},
	-- 	-- allows extending the enabled_providers array elsewhere in your config
	-- 	-- without having to redefining it
	-- 	opts_extend = { "sources.completion.enabled_providers" }
	-- },
	{
		"zbirenbaum/copilot-cmp",
		version = false,
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"Olical/conjure",
		ft = { "clojure", "fennel", "python", "racket" }, -- etc
		lazy = true,
		init = function()
			-- Set configuration options here
			-- Uncomment this to get verbose logging to help diagnose internal Conjure issues
			-- This is VERY helpful when reporting an issue with the project
			-- vim.g["conjure#debug"] = true
		end,

		-- Optional cmp-conjure integration
		dependencies = { "PaterJason/cmp-conjure" },
	},
	{
		"PaterJason/cmp-conjure",
		lazy = true,
		config = function()
			local cmp = require("cmp")
			local config = cmp.get_config()
			table.insert(config.sources, { name = "conjure" })
			return cmp.setup(config)
		end,
	},
}
