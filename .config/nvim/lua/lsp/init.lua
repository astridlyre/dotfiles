-- Lsp Configs
local lspconfig = require("lspconfig")
local lsp_config = {}
local enableTsServer = true

-- LSP Keymaps
local lsp_maps = function(bufnr)
	-- Normal keymap function
	local function nmap(keymap, action, opts)
		return vim.api.nvim_set_keymap("n", keymap, action, opts)
	end
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	local opts = { noremap = true, silent = true }
	nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	nmap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	nmap("K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	nmap("gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	nmap("<leader>lk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	nmap("<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	nmap("<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	nmap("<leader>wp", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	nmap("<leader>ld", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	nmap("<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	nmap("<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	nmap("<leader>le", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	nmap("<leader>ln", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	nmap("<leader>lp", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	nmap("<leader>lq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
	nmap("<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Generic On-Attach Function
local on_attach = function(no_format)
	return function(client, bufnr)
		lsp_maps(bufnr)
		if client.config.flags then
			client.config.flags.allow_incremental_sync = true
		end
		if no_format then
			client.resolved_capabilities.document_formatting = false
		end
	end
end

-- Snippet Support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

-- Diagnostic Handlers
local diagnostics = {
	virtual_text = { spacing = 0, prefix = "" },
	signs = { enable = true, priority = 20 },
	underline = true,
	update_in_insert = false,
}

local handlers = {
	["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, diagnostics),
}

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
		on_attach = on_attach(false),
		capabilities = capabilities,
		handlers = handlers,
	})
end

-- Deno for TypeScript
local function denols()
	local filetypes
	if enableTsServer then
		filetypes = { "typescript", "typescriptreact", "typescript.tsx" }
	else
		filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" }
	end
	lspconfig.denols.setup({
		on_attach = on_attach(false),
		capabilities = capabilities,
		init_options = { enable = true, lint = true, unstable = false },
		filetypes = filetypes,
		handlers = handlers,
	})
end

-- efm language server
local function efm()
	local languages = require("lsp.efm-ls").languages
	local filetypes = require("lsp.efm-ls").filetypes
	lspconfig.efm.setup({
		init_options = {
			documentFormatting = true,
			hover = false,
			documentSymbol = false,
			codeAction = false,
			completion = false,
		},
		root_dir = function()
			return vim.fn.getcwd()
		end,
		filetypes = filetypes,
		settings = { rootMarkers = { ".git/" }, languages = languages },
	})
end

-- Go Language Server
local function gopls()
	lspconfig.gopls.setup({
		cmd = { "gopls", "--remote=auto" },
		settings = {
			gopls = { analyses = { unusedparams = true }, staticcheck = true },
		},
		root_dir = lspconfig.util.root_pattern(".git", "go.mod", "."),
		init_options = { usePlaceholders = true, completeUnimported = true },
		on_attach = on_attach(false),
		capabilities = capabilities,
		handlers = handlers,
	})
end

-- Rust Analyzer
local function rust_analyzer()
	lspconfig.rust_analyzer.setup({
		on_attach = on_attach(false),
		capabilities = capabilities,
		handlers = handlers,
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
		on_attach = on_attach(true),
		handlers = handlers,
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
	})
end

-- TSserver for javascript (nodejs support)
local function tsserver()
	lspconfig.tsserver.setup({
		on_attach = on_attach(true),
		capabilities = capabilities,
		filetypes = { "javascript", "javascript.jsx", "javascriptreact" },
		handlers = handlers,
	})
end

-- Diagnostic Signs
local setup_diagnostic_defaults = function(default_diagnostics)
	vim.fn.sign_define("LspDiagnosticsSignError", {
		texthl = "LspDiagnosticsSignError",
		text = "",
		numhl = "LspDiagnosticsSignError",
	})
	vim.fn.sign_define("LspDiagnosticsSignWarning", {
		texthl = "LspDiagnosticsSignWarning",
		text = "",
		numhl = "LspDiagnosticsSignWarning",
	})
	vim.fn.sign_define("LspDiagnosticsSignHint", {
		texthl = "LspDiagnosticsSignHint",
		text = "",
		numhl = "LspDiagnosticsSignHint",
	})
	vim.fn.sign_define("LspDiagnosticsSignInformation", {
		texthl = "LspDiagnosticsSignInformation",
		text = "",
		numhl = "LspDiagnosticsSignInformation",
	})

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

	-- Set Default Prefix.
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics,
		default_diagnostics
	)
end

lsp_config.configure = function()
	setup_diagnostic_defaults(diagnostics)
	-- Enable the following default language servers
	local default_servers = {
		"pyright",
		"yamlls",
		"vimls",
		"html",
		"cssls",
		"dockerls",
		"cmake",
		"bashls",
		"clangd",
	}
	for _, ls in ipairs(default_servers) do
		lspconfig[ls].setup({
			on_attach = on_attach(true),
			capabilities = capabilities,
		})
	end

	-- Custom server configurations
	local custom_servers
	if enableTsServer then
		custom_servers = {
			clangd,
			denols,
			efm,
			gopls,
			rust_analyzer,
			sumneko_lua,
			tsserver,
		}
	else
		custom_servers = {
			clangd,
			denols,
			efm,
			gopls,
			rust_analyzer,
			sumneko_lua,
		}
	end
	for _, ls in ipairs(custom_servers) do
		ls()
	end

	-- Add reload lsp function
	function _G.reload_lsp()
		vim.lsp.stop_client(vim.lsp.get_active_clients())
		vim.cmd([[edit]])
	end
	vim.cmd("command! -nargs=0 LspRestart call v:lua.reload_lsp()")
end

return lsp_config
