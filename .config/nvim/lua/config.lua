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
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.g.indent_blankline_filetype_exclude = {
				"help",
				"packer",
				"NvimTree",
			}
			require("indent_blankline").setup({
				space_char_blankline = " ",
				show_current_context = true,
				show_current_context_start = true,
			})
		end,
	})
	use({
		"astridlyre/falcon",
		config = function()
			vim.cmd("colorscheme falcon")
		end,
	})
	use({
		"echasnovski/mini.nvim",
		config = function()
			require("mini.bufremove").setup({})
			require("mini.cursorword").setup({})
			require("mini.statusline").setup({})
			require("mini.tabline").setup({})
		end,
	})
	use({
		"norcalli/nvim-colorizer.lua",
		ft = {
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
		},
		config = function()
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
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" }, { "kyazdani42/nvim-web-devicons", opt = true } },
		config = function()
			local actions = require("telescope.actions")
			local telescope = require("telescope")
			telescope.setup({
				defaults = {

					prompt_prefix = " ",
					selection_caret = " ",
					path_display = { "smart" },

					mappings = {
						i = {
							["<C-n>"] = actions.cycle_history_next,
							["<C-p>"] = actions.cycle_history_prev,

							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,

							["<C-c>"] = actions.close,

							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,

							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,

							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,

							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,

							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-l>"] = actions.complete_tag,
							["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
						},
						n = {
							["<esc>"] = actions.close,
							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,

							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

							["j"] = actions.move_selection_next,
							["k"] = actions.move_selection_previous,
							["H"] = actions.move_to_top,
							["M"] = actions.move_to_middle,
							["L"] = actions.move_to_bottom,

							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,
							["gg"] = actions.move_to_top,
							["G"] = actions.move_to_bottom,

							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,

							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,

							["?"] = actions.which_key,
						},
					},
				},
			})
		end,
	})
	use({ "akinsho/toggleterm.nvim" })
	use("b3nj5m1n/kommentary")
	use({ "tpope/vim-dispatch", ft = { "clojure" } })
	use({ "clojure-vim/vim-jack-in", ft = { "clojure" } })
	use({ "Olical/conjure", ft = { "clojure" } })
	use({ "radenling/vim-dispatch-neovim", ft = { "clojure" } })
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
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

-- nvim tree
vim.g.nvim_tree_icons = {
	default = "",
	symlink = "",
	git = {
		unstaged = "",
		staged = "S",
		unmerged = "",
		renamed = "➜",
		deleted = "",
		untracked = "U",
		ignored = "◌",
	},
	folder = {
		default = "",
		open = "",
		empty = "",
		empty_open = "",
		symlink = "",
	},
}
local nvim_tree = require("nvim-tree")
local nvim_tree_config = require("nvim-tree.config")
local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup({
	disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	ignore_ft_on_setup = {
		"startify",
		"dashboard",
		"alpha",
	},
	auto_close = true,
	open_on_tab = false,
	hijack_cursor = false,
	update_cwd = true,
	update_to_buf_dir = {
		enable = true,
		auto_open = true,
	},
	diagnostics = {
		enable = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
		ignore_list = {},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	filters = {
		dotfiles = false,
		custom = {},
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 500,
	},
	view = {
		width = 30,
		height = 30,
		hide_root_folder = false,
		side = "left",
		auto_resize = true,
		mappings = {
			custom_only = false,
			list = {
				{ key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
				{ key = "h", cb = tree_cb("close_node") },
				{ key = "v", cb = tree_cb("vsplit") },
			},
		},
		number = false,
		relativenumber = false,
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
	quit_on_open = 0,
	git_hl = 1,
	disable_window_picker = 0,
	root_folder_modifier = ":t",
	show_icons = {
		git = 1,
		folders = 1,
		files = 1,
		folder_arrows = 1,
		tree_width = 30,
	},
})

require("toggleterm").setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
	open_mapping = [[<C-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 1,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "horizontal",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 3,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})
function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>h", [[<C-\><C-n><C-W>h]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>j", [[<C-\><C-n><C-W>j]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>k", [[<C-\><C-n><C-W>k]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>l", [[<C-\><C-n><C-W>l]], opts)
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

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
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>",
			scope_incremental = "<CR>",
			node_incremental = "<TAB>",
			node_decremental = "<S-TAB>",
		},
	},
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

-- Lsp Configs
local lspconfig = require("lspconfig")
local coq = require("coq")

-- LSP Keymaps
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
	nmap("<leader>lk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	nmap("<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	nmap("<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	nmap("<leader>wp", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	nmap("<leader>ld", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	nmap("<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	nmap("<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	nmap("<leader>ll", "<cmd>lua vim.diagnostic.open_float(nil, { source = 'always', border = 'rounded' })<CR>", opts)
	nmap("<leader>ln", "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>", opts)
	nmap("<leader>lp", "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>", opts)
	nmap("gl", "<cmd>lua vim.diagnostic.setqflist()<CR>", opts)
	nmap("<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	nmap("<leader>ld", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	nmap("<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
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

-- JSON LSP
local function jsonls()
	lspconfig.jsonls.setup(coq.lsp_ensure_capabilities({
		on_attach = on_attach(true),
		capabilities = capabilities,
		settings = {
			schemas = {
				{
					fileMatch = { "package.json" },
					url = "https://json.schemastore.org/package.json",
				},
				{
					fileMatch = { "tsconfig*.json" },
					url = "https://json.schemastore.org/tsconfig.json",
				},
				{
					fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
					url = "https://json.schemastore.org/prettierrc.json",
				},
				{
					fileMatch = { ".eslintrc", ".eslintrc.json" },
					url = "https://json.schemastore.org/eslintrc.json",
				},
				{
					fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
					url = "https://json.schemastore.org/babelrc.json",
				},
				{
					fileMatch = { "packer.json" },
					url = "https://json.schemastore.org/packer.json",
				},
			},
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
	"clangd",
	"sqls",
	"clojure_lsp",
	"racket_langserver",
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

-- Null LS
local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
null_ls.setup({
	sources = {
		formatting.prettierd.with({
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
		formatting.shfmt,
		formatting.black,
		formatting.fixjson,
		formatting.goimports,
		formatting.isort,
		formatting.sqlformat,
		formatting.rustfmt,
		formatting.stylua,
		diagnostics.shellcheck,
		diagnostics.eslint_d.with({
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			extra_args = { "--config", vim.fn.expand("~/.eslintrc.json") },
		}),
		diagnostics.flake8,
		diagnostics.markdownlint,
		diagnostics.vint,
	},
	on_attach = on_attach(true),
	capabilities = capabilities,
})
