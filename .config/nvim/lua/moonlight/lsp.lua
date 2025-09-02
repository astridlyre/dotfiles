local M = {}

local function get_diagnostic_at_cursor()
	local cur_buf = vim.api.nvim_get_current_buf()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	local entrys = vim.diagnostic.get(cur_buf, { lnum = line - 1 })
	local res = {}
	for _, v in pairs(entrys) do
		if v.col <= col and v.end_col >= col then
			table.insert(res, {
				code = v.code,
				message = v.message,
				range = {
					["start"] = {
						character = v.col,
						line = v.lnum,
					},
					["end"] = {
						character = v.end_col,
						line = v.end_lnum,
					},
				},
				severity = v.severity,
				source = v.source or nil,
			})
		end
	end
	return res
end

local lsp_maps = function(client, bufnr)
	local opts = { buffer = bufnr }

	vim.keymap.set('n', "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set('n', "K", vim.lsp.buf.hover, opts)
	vim.keymap.set('n', "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', "gr", vim.lsp.buf.references, opts)
	vim.keymap.set('n', "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set('n', "<leader>qf", vim.diagnostic.setqflist, opts)
	vim.keymap.set('n', "<leader>ca", function()
		return vim.lsp.buf.code_action({ context = { diagnostics = get_diagnostic_at_cursor() } })
	end)
	vim.keymap.set('n', "<leader>wp", function() return print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
	vim.keymap.set('n', "<leader>ld", function()
		return vim.diagnostic.open_float(nil, { source = "always", border = "rounded" })
	end)
	vim.keymap.set('n', "<c-j>",
		function() return vim.diagnostic.jump({ count = 1, float = { border = "rounded" } }) end)
	vim.keymap.set('n', "<c-k>",
		function() return vim.diagnostic.jump({ count = -1, float = { border = "rounded" } }) end)
end

-- Generic On-Attach Function
local on_attach = function(client, bufnr)
	lsp_maps(client, bufnr)
end

-- Client Capabilities
local function make_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	-- capabilities.textDocument.completion.completionItem.snippetSupport = true
	-- capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
	-- capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
	-- capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
	-- capabilities.textDocument.completion.completionItem.resolveSupport = {
	-- 	properties = { "documentation", "detail", "additionalTextEdits" },
	-- }
	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
	return capabilities
end

local capabilities = make_capabilities()

-- Lsp Configs
M.setup = function()
	local lspconfig = require("lspconfig")
	lsp_maps()

	-- clangd
	local function clangd()
		lspconfig.clangd.setup({
			cmd = {
				"clangd",
				"--background-index",
				"--suggest-missing-includes",
				"--clang-tidy",
				"--header-insertion=iwyu",
			},
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end

	-- Go Language Server
	local function gopls()
		lspconfig.gopls.setup({
			settings = {
				gopls = {
					analyses = { unusedparams = true, shadow = true },
					staticcheck = true,
					experimentalPostfixCompletions = true,
				},
			},
			init_options = { usePlaceholders = true, completeUnimported = true },
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end

	-- Rust Analyzer
	local function rust_analyzer()
		lspconfig.rust_analyzer.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					checkOnSave = {
						allFeatures = true,
						overrideCommand = {
							"cargo",
							"clippy",
							"--workspace",
							"--message-format=json",
							"--all-targets",
							"--all-features",
						},
					},
				},
			},
		})
	end

	-- Sumneko Language Server
	local function lua_ls()
		local library = {}
		local path = vim.split(package.path, ";", {})

		table.insert(path, "lua/?.lua")
		table.insert(path, "lua/?/init.lua")

		local function add(lib)
			for _, p in pairs(vim.fn.expand(lib, false, true)) do
				p = vim.loop.fs_realpath(p)
				library[p] = true
			end
		end

		add("$VIMRUNTIME")
		add("~/.config/nvim")
		add("~/.local/share/nvim/lazy/*")

		lspconfig.lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			on_new_config = function(config, root)
				local libs = vim.tbl_deep_extend("force", {}, library)
				libs[root] = nil
				config.settings.Lua.workspace.library = libs
				return config
			end,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						path = path,
					},
					completion = { callSnippet = "Both" },
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = library,
						maxPreload = 2000,
						preloadFileSize = 50000,
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		})
	end

	-- Enable the following default language servers
	local default_servers = {
		"pyright",
		"yamlls",
		"vimls",
		"html",
		"cssls",
		"dockerls",
		"bashls",
		"clojure_lsp",
		"eslint",
		"zls",
		"jsonls",
		"astro",
		"racket_langserver",
		--"biome",
		-- "templ",
		--"tailwindcss"
		-- "htmx-lsp",
	}

	for _, ls in ipairs(default_servers) do
		local cfg = {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		-- if ls == "html" or ls == "htmx-lsp" or ls == "tailwindcss" then
		-- 	cfg.filetypes = { "html", "templ" }
		-- end

		lspconfig[ls].setup(cfg)
	end

	-- Custom server configurations
	for _, ls in ipairs({
		clangd,
		gopls,
		rust_analyzer,
		lua_ls,
	}) do
		ls()
	end

	vim.diagnostic.config({
		virtual_text = false,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.INFO] = "",
				[vim.diagnostic.severity.HINT] = "",

			}
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			show_header = false,
			focusable = false,
			source = "if_many",
			header = "",
			prefix = "",
		},
	})

	vim.lsp.set_log_level("OFF")
end

M.make_capabilities = make_capabilities

return M
