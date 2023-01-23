local M = {}

local utils = require("moonlight.utils")
local nmap = utils.nmap
local imap = utils.imap

-- Servers to disable formatting by default (so they don't conflict with null-ls)
local disable_formatting = { "tsserver", "jsonls", "gopls", "html", "cssls", "racket_langserver", "eslint" }
local enable_formatting_on_save = true

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			if vim.tbl_contains(disable_formatting, client.name) then
				return false
			end
			return true
		end,
		bufnr = bufnr,
	})
end

local lsp_maps = function(_, bufnr)
	local opts = { buffer = bufnr }
	nmap("gD", vim.lsp.buf.declaration, opts)
	nmap("gd", vim.lsp.buf.definition, opts)
	nmap("K", vim.lsp.buf.hover, opts)
	nmap("gi", vim.lsp.buf.implementation, opts)
	nmap("gr", vim.lsp.buf.references, opts)
	nmap("<space>wa", vim.lsp.buf.add_workspace_folder, opts)
	nmap("<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
	nmap("<space>ld", vim.lsp.buf.type_definition, opts)
	nmap("<space>rn", vim.lsp.buf.rename, opts)
	nmap("<space>qf", vim.diagnostic.setqflist)
	nmap("<space>lf", vim.lsp.buf.formatting_sync)
	nmap("<space>ca", vim.lsp.buf.code_action)
	nmap("<c-s>", vim.lsp.buf.signature_help, opts)
	imap("<c-s>", vim.lsp.buf.signature_help, opts)

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

	nmap("<space>lf", function()
		return lsp_formatting()
	end)
end

-- Generic On-Attach Function
local on_attach = function(client, bufnr)
	lsp_maps(client, bufnr)
	if
		enable_formatting_on_save
		and client.server_capabilities.documentFormattingProvider
		and not vim.tbl_contains(disable_formatting, client.name)
	then
		vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua require('moonlight.autoformat').format(]] .. bufnr .. [[)
            augroup END
            ]])
	end
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
local flags = { debounce_text_changes = 150, allow_incremental_sync = true }

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
			flags = flags,
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
			flags = flags,
		})
	end

	-- Rust Analyzer
	local function rust_analyzer()
		lspconfig.rust_analyzer.setup({
			flags = flags,
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
	local function sumneko_lua()
		local library = {}
		local path = vim.split(package.path, ";")

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
		add("~/.local/share/nvim/site/pack/packer/opt/*")
		add("~/.local/share/nvim/site/pack/packer/start/*")

		lspconfig.sumneko_lua.setup({
			flags = flags,
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

	-- TSserver for javascript (nodejs support)
	local function tsserver()
		return lspconfig.tsserver.setup({
			flags = flags,
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = {
				"javascript",
				"javascript.jsx",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			init_options = {
				hostInfo = "neovim",
				preferences = {
					importModuleSpecifierPreference = "project-relative",
					includeCompletionsForModuleExports = false,
					includeCompletionsForImportStatements = false,
				},
				maxTsServerMemory = 12288,
			},
			settings = {
				diagnosticsDelay = "150ms",
				experimentalWatchedFileDelay = "850ms",
			},
		})
	end

	--[[ local function sqls()
		lspconfig.sqls.setup({
			flags = flags,
			on_attach = function(client, bufnr)
				require("sqls").on_attach(client, bufnr)
				return on_attach(client, bufnr)
			end,
			capabilities = capabilities,
		})
	end ]]

	-- JSON LSP
	local function jsonls()
		lspconfig.jsonls.setup({
			flags = flags,
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				schemas = require("schemastore").json.schemas({
					select = {
						"package.json",
						"tsconfig.json",
						"prettierrc.json",
						".eslintrc",
						"babelrc.json",
						"Packer",
						"swcrc",
						".adonisrc.json",
						"docker-compose.yml",
					},
				}),
			},
		})
	end

	--[[ local function racketls()
		lspconfig.racket_langserver.setup({
			flags = flags,
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "racket" },
		})
	end ]]

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
		--"cssmodules_ls",
		--"emmet_ls",
		--"solang",
		"eslint",
	}

	for _, ls in ipairs(default_servers) do
		lspconfig[ls].setup({
			on_attach = on_attach,
			capabilities = capabilities,
			flags = flags,
		})
	end

	-- Custom server configurations
	for _, ls in ipairs({
		clangd,
		gopls,
		rust_analyzer,
		sumneko_lua,
		-- sqls,
		tsserver,
		jsonls,
		--racketls,
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
			style = "minimal",
			border = "solid",
			source = "if_many",
			header = "",
			prefix = "",
		},
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "solid",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "solid",
	})

	vim.lsp.set_log_level("OFF")

	-- Add reload lsp function
	function _G.reload_lsp()
		vim.lsp.stop_client(vim.lsp.get_active_clients())
		vim.cmd([[edit]])
	end

	vim.cmd("command! -nargs=0 LspRestart call v:lua.reload_lsp()")
end

M.make_capabilities = make_capabilities
M.flags = flags
M.lsp_format = lsp_formatting

return M
