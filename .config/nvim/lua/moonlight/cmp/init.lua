return function()
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	local source_mapping = {
		buffer = "[Buffer]",
		nvim_lsp = "[LSP]",
		nvim_lua = "[Lua]",
		path = "[Path]",
	}

	local luasnip = require("luasnip")
	require("luasnip.loaders.from_vscode").load()

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

	vim.keymap.set("i", "<C-j>", snippet_next)
	vim.keymap.set("i", "<C-k>", snippet_prev)

	cmp.setup({
		throttle_time = 10,
		debug = false,
		preselect = "enable",
		source_timeout = 200,
		documentation = true,
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		mapping = {
			["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<C-e>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "conjure" },
		}),
		formatting = {
			format = lspkind.cmp_format({
				with_text = false,
				maxwidth = 50,
				before = function(entry, vim_item)
					vim_item.menu = source_mapping[entry.source.name]
					return vim_item
				end,
			}),
		},
	})
end
