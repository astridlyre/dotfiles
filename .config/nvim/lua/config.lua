-- Install packer if not installed
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end
vim.api.nvim_exec(
	[[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]],
	false
)
local remap = vim.api.nvim_set_keymap

-- Load plugins
local use = require("packer").use
require("packer").startup(function()
	use("wbthomason/packer.nvim")
	use({
		"ms-jpq/coq_nvim",
		branch = "coq",
		run = ":COQdeps",
	})
	use({ "ms-jpq/coq.artifacts", branch = "artifacts" })
	use({
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
	})
	use({
		"astridlyre/falcon",
		config = function()
			vim.cmd("colorscheme falcon")
		end,
	})
	use("echasnovski/mini.nvim")
	use({ "norcalli/nvim-colorizer.lua" })
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" }, { "kyazdani42/nvim-web-devicons", opt = true } },
	})
	use("b3nj5m1n/kommentary")
	use("tpope/vim-fugitive")
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use({
		"clojure-vim/acid.nvim",
		run = ":UpdateRemotePlugins",
	})
	use({ "nvim-treesitter/nvim-treesitter-textobjects" })
	use({ "windwp/nvim-ts-autotag" })
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	})
	use({ "neovim/nvim-lspconfig" })
	use({
		"ray-x/lsp_signature.nvim",
		opt = true,
		event = "InsertCharPre",
		config = function()
			-- LSP Signature
			local cfg = {
				bind = true,
				doc_lines = 0,
				floating_window = true,
				floating_window_above_cur_line = true,
				hint_enable = true,
				hint_prefix = "❱ ",
				hint_scheme = "String",
				use_lspsaga = false,
				hi_parameter = "Search",
				max_height = 4,
				max_width = 120,
				handler_opts = { border = "single" },
				extra_trigger_chars = {},
			}
			require("lsp_signature").on_attach(cfg)
		end,
	})
	use({ "windwp/nvim-autopairs" })
end)

require("mini.bufremove").setup({})
require("mini.cursorword").setup({})
require("mini.statusline").setup({})
require("mini.tabline").setup({})

-- File tree
require("nvim-tree").setup({
	view = {
		width = 30,
		auto_resize = true,
		mappings = {
			custom_only = false,
			list = {
				{ key = "s", cb = ':lua require("telescope.builtin").find_files()<cr>' },
			},
		},
	},
	system_open = {
		cmd = nil,
	},
})

-- Colorizer
require("colorizer").setup({
	"css",
	"javascript",
	"html",
	"yaml",
	"sass",
	"markdown",
	"lua",
	"typescript",
	"vim",
	"sh",
	"bash",
	"scss",
})

-- Gitsigns
require("gitsigns").setup({
	signs = {
		add = { hl = "GitGutterAdd", text = "+" },
		change = { hl = "GitGutterChange", text = "~" },
		delete = { hl = "GitGutterDelete", text = "_" },
		topdelete = { hl = "GitGutterDelete", text = "‾" },
		changedelete = { hl = "GitGutterChange", text = "~" },
	},
})

-- Treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = "maintained",
	highlight = { enable = true },
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["ap"] = "@parameter.outer",
				["ip"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = { ["<leader>sn"] = "@parameter.inner" },
			swap_previous = { ["<leader>sp"] = "@parameter.inner" },
		},
	},
	autotag = { enable = true },
	autopairs = { enable = true },
	matchup = {
		enable = true, -- mandatory, false will disable the whole extension
	},
	move = {
		enable = true,
		set_jumps = true, -- whether to set jumps in the jumplist
		goto_next_start = {
			["]m"] = "@function.outer",
			["]]"] = "@class.outer",
		},
		goto_next_end = {
			["]M"] = "@function.outer",
			["]["] = "@class.outer",
		},
		goto_previous_start = {
			["[m"] = "@function.outer",
			["[["] = "@class.outer",
		},
		goto_previous_end = {
			["[M"] = "@function.outer",
			["[]"] = "@class.outer",
		},
	},
})

vim.g.coq_settings = {
	match = {
		exact_matches = 3,
		fuzzy_cutoff = 0.7,
		look_ahead = 1,
	},
	weights = {
		prefix_matches = 2.0,
		edit_distance = 1.0,
		recency = 0.75,
		proximity = 1.0,
	},
	keymap = { recommended = false },
	display = {
		icons = { mode = "short" },
		ghost_text = { enabled = false },
		preview = { positions = {
			north = 4,
			south = 3,
			east = 1,
			west = 2,
		} },
	},
	clients = {
		buffers = {
			same_filetype = true,
			enabled = true,
			weight_adjust = -1.5,
		},
		tree_sitter = {
			enabled = true,
			weight_adjust = 0.6,
		},
		lsp = {
			enabled = true,
			weight_adjust = 2.0,
			resolve_timeout = 0.08,
		},
		snippets = {
			enabled = true,
			weight_adjust = 1.5,
		},
	},
	auto_start = "shut-up",
	limits = {
		completion_auto_timeout = 0.2,
	},
}
remap("i", "<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
remap("i", "<c-c>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })

-- Autopairs
local npairs = require("nvim-autopairs")
npairs.setup({ map_bs = false, enable_check_bracket_line = false, ignored_next_char = "[%w%.]" })
_G.MUtils = {}
MUtils.CR = function()
	if vim.fn.pumvisible() ~= 0 then
		return npairs.esc("<c-e>") .. npairs.autopairs_cr()
	else
		return npairs.autopairs_cr()
	end
end
remap("i", "<cr>", "v:lua.MUtils.CR()", { expr = true, noremap = true })
MUtils.BS = function()
	if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
		return npairs.esc("<c-e>") .. npairs.autopairs_bs()
	else
		return npairs.autopairs_bs()
	end
end
remap("i", "<bs>", "v:lua.MUtils.BS()", { expr = true, noremap = true })

-- Null LS
local null_ls = require("null-ls")
local sources = {
	null_ls.builtins.formatting.prettierd.with({
		filetypes = {
			"html",
			"yaml",
			"markdown",
			"javascript",
			"javascriptreact",
			"css",
			"scss",
			"html",
			"typescript",
			"typescriptreact",
		},
	}),
	null_ls.builtins.formatting.shfmt,
	null_ls.builtins.formatting.black,
	null_ls.builtins.formatting.fixjson,
	null_ls.builtins.formatting.goimports,
	null_ls.builtins.formatting.isort,
	null_ls.builtins.formatting.sqlformat,
	null_ls.builtins.formatting.rustfmt,
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.diagnostics.shellcheck,
	null_ls.builtins.diagnostics.eslint_d.with({
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		extra_args = { "--config", vim.fn.expand("~/.eslintrc.json") },
	}),
	null_ls.builtins.diagnostics.flake8,
	null_ls.builtins.diagnostics.markdownlint,
	null_ls.builtins.diagnostics.vint,
}
null_ls.config({
	sources = sources,
})

-- Lsp Configs
local lspconfig = require("lspconfig")
local coq = require("coq")

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
		on_attach = on_attach(false),
		capabilities = capabilities,
	}))
end

-- Deno for TypeScript
--[[ local function denols()
	local filetypes = { "typescript", "typescriptreact", "typescript.tsx" }
	lspconfig.denols.setup(coq.lsp_ensure_capabilities({
		on_attach = on_attach(false),
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
		on_attach = on_attach(false),
		capabilities = capabilities,
	}))
end

-- Rust Analyzer
local function rust_analyzer()
	lspconfig.rust_analyzer.setup(coq.lsp_ensure_capabilities({
		on_attach = on_attach(true),
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
		on_attach = on_attach(true),
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
	lspconfig.tsserver.setup(coq.lsp_ensure_capabilities({
		on_attach = on_attach(true),
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
			includePackageJsonAutoImports = true,
		},
	}))
end

local function sqls()
	lspconfig.sqls.setup(coq.lsp_ensure_capabilities({
		on_attach = on_attach(false),
		capabilities = capabilities,
	}))
end

-- Enable the following default language servers
local default_servers = {
	"pyright",
	"yamlls",
	"vimls",
	"html",
	"jsonls",
	"cssls",
	"dockerls",
	"bashls",
	"clangd",
	"sqls",
	"clojure_lsp",
	"null-ls",
}
for _, ls in ipairs(default_servers) do
	lspconfig[ls].setup(coq.lsp_ensure_capabilities({
		on_attach = on_attach(true),
		capabilities = capabilities,
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
}) do
	ls()
end

-- Diagnostic Signs
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

vim.fn.sign_define("DiagnosticSignError", {
	texthl = "DiagnosticSignError",
	text = "",
	numhl = "DiagnosticSignError",
})
vim.fn.sign_define("DiagnosticSignWarn", {
	texthl = "DiagnosticSignWarn",
	text = "",
	numhl = "DiagnosticSignWarn",
})
vim.fn.sign_define("DiagnosticSignHint", {
	texthl = "DiagnosticSignHint",
	text = "",
	numhl = "DiagnosticSignHint",
})
vim.fn.sign_define("DiagnosticSignInfo", {
	texthl = "DiagnosticSignInfo",
	text = "",
	numhl = "DiagnosticSignInfo",
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

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = {
		prefix = "",
		source = "if_many", -- Or "if_many"
	},
})

-- Add reload lsp function
function _G.reload_lsp()
	vim.lsp.stop_client(vim.lsp.get_active_clients())
	vim.cmd([[edit]])
end
vim.cmd("command! -nargs=0 LspRestart call v:lua.reload_lsp()")
