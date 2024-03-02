return {
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
			{ "onsails/lspkind-nvim" },
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")
			local utils = require("moonlight.utils")
			local imap = utils.imap

			local unlinkgrp = vim.api.nvim_create_augroup("UnlinkSnippetOnModeChange", { clear = true })

			vim.api.nvim_create_autocmd("ModeChanged", {
				group = unlinkgrp,
				pattern = { "s:n", "i:*" },
				desc = "Forget the snippet on mode change",
				callback = function(evt)
					if
						luasnip
						and luasnip.session
						and luasnip.session.current_nodes[evt.buf]
						and not luasnip.session.jump_active
					then
						luasnip.unlink_current()
					end
				end,
			})

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
							{ name = "vim-dadbod-completion" },
						},
					})
				end,
				group = autocomplete_group,
			})

			local sources = cmp.config.sources({
				{ name = "luasnip" },
				{ name = "copilot", group_index = 2 },
				{ name = "nvim_lsp" },
				-- { name = "conjure" },
				{ name = "nvim_lua" },
				{ name = "git" },
				{ name = "buffer" },
			})

			local format = lspkind.cmp_format({
				mode = "symbol", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
				-- menu = ({ -- showing type in menu
				--   nvim_lsp = "(LSP)",
				--   path = "(Path)",
				--   buffer = "(Buffer)",
				--   luasnip = "(LuaSnip)",
				-- }),
				menu = {
					buffer = "[Buffer]",
					nvim_lsp = "[LSP]",
					vsnip = "[Snippet]",
					tags = "[Tag]",
					path = "[Path]",
					["vim-dadbod-completion"] = "[DB]",
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
		"petertriho/cmp-git",
		lazy = true,
		ft = { "gitcommit", "octo" },
		config = function()
			require("cmp_git").setup()
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
		"james1236/backseat.nvim",
		cmd = { "Backseat", "BackseatAsk", "BackseatClear", "BackseatClearLine" },
		config = function()
			require("backseat").setup({
				openai_api_key = "", -- Get yours from platform.openai.com/account/api-keys
				openai_model_id = "gpt-4", --gpt-4
				-- split_threshold = 100,
				additional_instruction = "Respond with sass", -- (GPT-3 will probably deny this request, but GPT-4 complies)
				highlight = {
					icon = "", -- ''
					group = "Comment",
				},
			})
		end,
	},
}
