local M = {}

local utils = require("moonlight.utils")
local nmap = utils.nmap
local imap = utils.imap

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
	nmap("gD", vim.lsp.buf.declaration, opts)

	nmap("gd", function()
		if vim.tbl_contains({ "javascript", "typescript", "javascriptreact", "typescriptreact" }, vim.bo.filetype) then
			vim.cmd("TSToolsGoToSourceDefinition")
			return
		end

		vim.lsp.buf.definition()
	end, opts)

	nmap("K", vim.lsp.buf.hover, opts)
	nmap("gi", vim.lsp.buf.implementation, opts)
	nmap("gr", vim.lsp.buf.references, opts)
	nmap("<space>wa", vim.lsp.buf.add_workspace_folder, opts)
	nmap("<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
	nmap("<space>rn", vim.lsp.buf.rename, opts)
	nmap("<space>qf", vim.diagnostic.setqflist, opts)
	nmap("<c-s>", vim.lsp.buf.signature_help, opts)
	imap("<c-s>", vim.lsp.buf.signature_help, opts)

	nmap("<space>ca", function()
		return vim.lsp.buf.code_action({
			context = {
				diagnostics = get_diagnostic_at_cursor(),
			},
		})
	end)

	nmap("<space>wp", function()
		return print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end)

	nmap("<space>ll", function()
		return vim.diagnostic.open_float(nil, { source = "always", border = "solid" })
	end)

	nmap("<c-j>", function()
		return vim.diagnostic.goto_next({ border = "solid" })
	end)

	nmap("<c-k>", function()
		return vim.diagnostic.goto_prev({ border = "solid" })
	end)
end

-- Generic On-Attach Function
local on_attach = function(client, bufnr)
	lsp_maps(client, bufnr)
end

-- Client Capabilities
local function make_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
	capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
	capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
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
			-- flags = flags,
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
			-- flags = flags,
		})
	end

	-- Rust Analyzer
	local function rust_analyzer()
		lspconfig.rust_analyzer.setup({
			-- flags = flags,
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
			-- flags = flags,
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
		"templ",
		-- "htmx-lsp",
	}

	for _, ls in ipairs(default_servers) do
		local cfg = {
			on_attach = on_attach,
			capabilities = capabilities,
			-- flags = flags,
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

	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
	end

	vim.diagnostic.config({
		virtual_text = false,
		signs = {
			active = signs,
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			show_header = false,
			focusable = false,
			border = "rounded",
			source = "if_many",
			header = "",
			prefix = "",
		},
	})

	require("lspconfig.ui.windows").default_options.border = "rounded"

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})

	vim.lsp.set_log_level("OFF")
end

M.make_capabilities = make_capabilities

return M
