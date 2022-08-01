return function()
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
		buffer = "[buf]",
		nvim_lsp = "[lsp]",
		nvim_lua = "[lua]",
		path = "[path]",
	}

	local sources = cmp.config.sources({
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		--{ name = "conjure" },
		{ name = "path" },
		{ name = "buffer" },
	})

	local format = lspkind.cmp_format({
		mode = "symbol",
		maxwidth = 50,
		before = function(entry, vim_item)
			vim_item.menu = source_mapping[entry.source.name]
			return vim_item
		end,
	})

	-- setup cmp
	cmp.setup({
		throttle_time = 10,
		debug = false,
		source_timeout = 250,
		snippet = { expand = expand },
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<C-e>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			["<c-y>"] = cmp.mapping.confirm({ select = true }),
		}),
		sources = sources,
		formatting = { format = format },
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
	})
end
