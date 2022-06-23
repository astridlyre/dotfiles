local M = {}

local utils = require("moonlight.utils")
local util = require("vim.lsp.util")
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
	nmap("<c-s>", vim.lsp.buf.signature_help, opts)
	imap("<c-s>", vim.lsp.buf.signature_help, opts)

	nmap("<space>wp", function()
		return print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end)

	nmap("<space>ll", function()
		return vim.diagnostic.open_float(nil, { source = "always", border = "rounded" })
	end)

	nmap("<c-j>", function()
		return vim.diagnostic.goto_next({ border = "rounded" })
	end)

	nmap("<c-k>", function()
		return vim.diagnostic.goto_prev({ border = "rounded" })
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
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
	return capabilities
end

local capabilities = make_capabilities()
local flags = { debounce_text_changes = 250, allow_incremental_sync = true }

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
		local sumneko_root_path = vim.fn.getenv("HOME") .. "/.local/lua-language-server"
		local sumneko_binary_path = "/bin/Linux/lua-language-server"

		lspconfig.sumneko_lua.setup({
			flags = flags,
			on_attach = on_attach,
			capabilities = capabilities,
			cmd = {
				sumneko_root_path .. sumneko_binary_path,
				"-E",
				sumneko_root_path .. "/main.lua",
			},
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						path = vim.split(package.path, ";"),
					},
					diagnostics = { globals = { "vim" } },
					telemetry = { enable = false },
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						},
						maxPreload = 10000,
					},
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
				importModuleSpecifierEnding = "auto",
				importModuleSpecifierPreference = "project-relative",
				includePackageJsonAutoImports = "auto",
				includeCompletionsForModuleExports = false,
				includeCompletionsForImportStatements = false,
				maxTsServerMemory = 12288,
			},
			settings = {
				diagnosticsDelay = "200ms",
				experimentalWatchedFileDelay = "1000ms",
			},
		})
	end

	local function sqls()
		lspconfig.sqls.setup({
			flags = flags,
			on_attach = function(client, bufnr)
				require("sqls").on_attach(client, bufnr)
				return on_attach(client, bufnr)
			end,
			capabilities = capabilities,
		})
	end

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

	local function racketls()
		lspconfig.racket_langserver.setup({
			flags = flags,
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "racket" },
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
		--"cssmodules_ls",
		--"emmet_ls",
		"solang",
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
		sqls,
		tsserver,
		jsonls,
		racketls,
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
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})

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
