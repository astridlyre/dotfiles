return {
	{
		'saghen/blink.cmp',
		-- commit = '0194153e0a5646097801578813bde085c94ecaef',
		build = function()
			require("blink.cmp").build():wait(60000)
		end,
		dependencies = {
			{ 'saghen/blink.lib', -- commit = '220979f3fcd388a08990189bc3b4e82aa1637ce9'
			},
			{ dir = "~/projects/friendly-snippets", dev = true },
			"giuxtaposition/blink-cmp-copilot",
			'Kaiser-Yang/blink-cmp-dictionary', -- Required for dictionary completion
		},

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			fuzzy = { implementation = "rust" },
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
				kind_icons = {

					Copilot = "",
					Text = '󰉿',
					Method = '󰊕',
					Function = '󰊕',
					Constructor = '󰒓',

					Field = '󰜢',
					Variable = '󰆦',
					Property = '󰖷',

					Class = '󱡠',
					Interface = '󱡠',
					Struct = '󱡠',
					Module = '󰅩',

					Unit = '󰪚',
					Value = '󰦨',
					Enum = '󰦨',
					EnumMember = '󰦨',

					Keyword = '󰻾',
					Constant = '󰏿',

					Snippet = '󱄽',
					Color = '󰏘',
					File = '󰈔',
					Reference = '󰬲',
					Folder = '󰉋',
					Event = '󱐋',
					Operator = '󰪚',
					TypeParameter = '󰬛',
				},
			},

			enabled = function()
				return not vim.tbl_contains({ "TelescopePrompt", "DressingSelect", "DressingInput" }, vim.bo.filetype)
					and vim.bo.buftype ~= "prompt"
					and vim.b.completion ~= false
			end,

			cmdline = { enabled = false },

			completion = {
				trigger = { prefetch_on_insert = false },
				accept = { auto_brackets = { enabled = true } },

				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					treesitter_highlighting = true,
				},

				list = { selection = { preselect = true, auto_insert = true } },

				menu = {
					cmdline_position = function()
						if vim.g.ui_cmdline_pos ~= nil then
							local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
							return { pos[1] - 1, pos[2] }
						end
						local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
						return { vim.o.lines - height, 0 }
					end,

					draw = {
						columns = { { 'item_idx' }, { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
						components = {
							item_idx = {
								text = function(ctx)
									return ctx.idx == 10 and '0' or ctx.idx >= 10 and ' ' or
										tostring(ctx.idx)
								end,
								highlight = 'BlinkCmpItemIdx' -- optional, only if you want to change its color
							}
						},
					},
				},
			},

			keymap = {
				preset = "none",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<C-y>"] = { "accept", "fallback" },
				["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
				["<C-j>"] = { "snippet_forward", "accept", "fallback" },
				["<C-k>"] = { "snippet_backward", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback_to_mappings" },
				["<C-n>"] = { "select_next", "fallback_to_mappings" },
				["<C-up>"] = { "scroll_documentation_up", "fallback" },
				["<C-down>"] = { "scroll_documentation_down", "fallback" },
				['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
				['<A-2>'] = { function(cmp) cmp.accept({ index = 2 }) end },
				['<A-3>'] = { function(cmp) cmp.accept({ index = 3 }) end },
				['<A-4>'] = { function(cmp) cmp.accept({ index = 4 }) end },
				['<A-5>'] = { function(cmp) cmp.accept({ index = 5 }) end },
				['<A-6>'] = { function(cmp) cmp.accept({ index = 6 }) end },
				['<A-7>'] = { function(cmp) cmp.accept({ index = 7 }) end },
				['<A-8>'] = { function(cmp) cmp.accept({ index = 8 }) end },
				['<A-9>'] = { function(cmp) cmp.accept({ index = 9 }) end },
				['<A-0>'] = { function(cmp) cmp.accept({ index = 10 }) end },
			},

			signature = { enabled = true },

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "copilot" },
				per_filetype = {
					lilypond = { 'dictionary', 'buffer' }
				},
				providers = {
					dictionary = {
						name = "Dict",
						module = "blink-cmp-dictionary",
						min_keyword_length = 3,
						score_offset = 100,
						max_items = 5,
						opts = {
							dictionary_files = function()
								if vim.bo.filetype == 'lilypond' then
									return vim.fn.glob(vim.fn.expand("$LILYDICTPATH") .. "/*", true, true)
								end
							end,
						},
					},
					lsp = {
						min_keyword_length = 1, -- Number of characters to trigger provider
						score_offset = 50, -- Boost/penalize the score of the items
					},
					path = {
						min_keyword_length = 1,
					},
					snippets = {
						min_keyword_length = 1,
						score_offset = 200,
						max_items = 3
					},
					buffer = {
						min_keyword_length = 5,
						max_items = 2,
					},
					copilot = {
						name = "Copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
						max_items = 2,
						transform_items = function(_, items)
							local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
							local kind_idx = #CompletionItemKind + 1
							CompletionItemKind[kind_idx] = "Copilot"
							for _, item in ipairs(items) do
								item.kind = kind_idx
								item.kind_icon = ""
							end
							return items
						end,
					}
				},
			},
		},
	},
	{
		"yuukiflow/Arduino-Nvim",
		ft = "arduino",
		opts = {
			picker_backend = "nvim"
		},
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	}
}
