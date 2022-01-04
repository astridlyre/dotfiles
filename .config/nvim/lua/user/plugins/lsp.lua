local M = {}

-- Servers to disable formatting by default (so they don't conflict with null-ls)
local disable_formatting = { "tsserver", "jsonls" }

local lsp_maps = function(bufnr)
	-- Normal keymap function
	local function nmap(keymap, action, opts)
		return vim.api.nvim_buf_set_keymap(bufnr, "n", keymap, action, opts)
	end

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true }

	nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	nmap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	nmap("K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	nmap("gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	nmap("<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	nmap("<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	nmap("<space>wp", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	nmap("<space>ld", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	nmap("<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	nmap("<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	nmap("<space>ll", '<cmd>lua vim.diagnostic.open_float(nil, { source = "always", border = "rounded" })<CR>', opts)
	nmap("<c-j>", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
	nmap("<c-k>", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
	nmap("gq", "<cmd>lua vim.diagnostic.setqflist()<CR>", opts)
	nmap("<space>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	nmap("<space>fs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
end

-- Configuration for LSP signature
local lsp_signature_config = {
	bind = true,
	doc_lines = 0,
	floating_window = true,
	floating_window_above_cur_line = true,
	hint_enable = false,
	hint_prefix = "❱ ",
	hint_scheme = "String",
	use_lspsaga = false,
	hi_parameter = "Search",
	max_height = 4,
	max_width = 120,
	handler_opts = { border = "single" },
	extra_trigger_chars = {},
}

-- Generic On-Attach Function
local on_attach = function(client, bufnr)
	lsp_maps(bufnr)

	for _, ls in ipairs(disable_formatting) do
		if client.name == ls then
			client.resolved_capabilities.document_formatting = false
		end
	end

	require("lsp_signature").on_attach(lsp_signature_config, bufnr)
end

-- Snippet Support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

local flags = { debounce_text_changes = 150, allow_incremental_sync = true }

-- Lsp Configs
M.setup = function()
	local lspconfig = require("lspconfig")
	local coq = require("coq")

	-- clangd
	local function clangd()
		lspconfig.clangd.setup(coq.lsp_ensure_capabilities({
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
		}))
	end

	-- Deno for TypeScript
	--[[ local function denols()
	local filetypes = { "typescript", "typescriptreact", "typescript.tsx" }
	lspconfig.denols.setup(coq.lsp_ensure_capabilities({
		on_attach = on_attach,
		capabilities = capabilities,
		init_options = { enable = true, lint = true, unstable = true },
		filetypes = filetypes,
	}))
end ]]

	-- Go Language Server
	local function gopls()
		lspconfig.gopls.setup(coq.lsp_ensure_capabilities({
			cmd = { "gopls", "--remote=auto" },
			settings = {
				gopls = { analyses = { unusedparams = true }, staticcheck = true },
			},
			root_dir = lspconfig.util.root_pattern(".git", "go.mod", "."),
			init_options = { usePlaceholders = true, completeUnimported = true },
			on_attach = on_attach,
			capabilities = capabilities,
			flags = flags,
		}))
	end

	-- Rust Analyzer
	local function rust_analyzer()
		lspconfig.rust_analyzer.setup(coq.lsp_ensure_capabilities({
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
		}))
	end

	-- Sumneko Language Server
	local function sumneko_lua()
		local sumneko_root_path = vim.fn.getenv("HOME") .. "/.local/lua-language-server"
		local sumneko_binary_path = "/bin/Linux/lua-language-server"

		lspconfig.sumneko_lua.setup(coq.lsp_ensure_capabilities({
			flags = flags,
			on_attach = on_attach,
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
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						},
						maxPreload = 10000,
					},
				},
			},
		}))
	end

	-- TSserver for javascript (nodejs support)
	local function tsserver()
		return lspconfig.tsserver.setup(coq.lsp_ensure_capabilities({
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
				includeCompletionsForImportStatements = true,
				includeAutomaticOptionalChainCompletions = true,
				importModuleSpecifierEnding = "js",
				importModuleSpecifierPreference = "project-relative",
				includePackageJsonAutoImports = true,
			},
		}))
	end

	local function sqls()
		lspconfig.sqls.setup(coq.lsp_ensure_capabilities({
			flags = flags,
			on_attach = on_attach,
			capabilities = capabilities,
		}))
	end

	-- JSON LSP
	local function jsonls()
		lspconfig.jsonls.setup(coq.lsp_ensure_capabilities({
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
						"Ansible Role",
						"Ansible Playbook",
						"Ansible Inventory",
						"docker-compose.yml",
					},
				}),
			},
		}))
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
		"racket_langserver",
		"cssmodules_ls",
		"emmet_ls",
		"solang",
	}

	for _, ls in ipairs(default_servers) do
		lspconfig[ls].setup(coq.lsp_ensure_capabilities({
			on_attach = on_attach,
			capabilities = capabilities,
			flags = flags,
		}))
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
	}) do
		ls()
	end

	-- symbols for autocomplete
	vim.lsp.protocol.CompletionItemKind = {
		"   ",
		"   ",
		"   ",
		"   ",
		" ﴲ  ",
		"[] ",
		"   ",
		" ﰮ  ",
		"   ",
		" 襁 ",
		"   ",
		"   ",
		" 練 ",
		"   ",
		"   ",
		"   ",
		"   ",
		"   ",
		"   ",
		"   ",
		" ﲀ  ",
		" ﳤ  ",
		"   ",
		"   ",
		"   ",
	}

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

M.on_attach = on_attach
M.capabilities = capabilities
M.flags = flags

return M
