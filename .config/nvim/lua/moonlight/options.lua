local M = {}

local utils = require("moonlight.utils")

local nmap = utils.nmap
local tmap = utils.tmap
local vmap = utils.vmap
local cmap = utils.cmap
local lmap = utils.lmap
local imap = utils.imap

local function set_globals()
	local g = vim.g

	g.loaded_2html_plugin = 1
	g.loaded_getscript = 1
	g.loaded_getscriptPlugin = 1
	g.loaded_gzip = 1
	g.loaded_logiPat = 1
	g.loaded_matchit = 1
	g.loaded_matchparen = 1
	g.loaded_netrw = 1
	g.loaded_netrwPlugin = 1
	g.loaded_perl_provider = 0
	g.loaded_python_provider = 0
	g.loaded_rrhelper = 1
	g.loaded_ruby_provider = 0
	g.loaded_tar = 1
	g.loaded_tarPlugin = 1
	g.loaded_vimball = 1
	g.loaded_vimballPlugin = 1
	g.loaded_zip = 1
	g.loaded_zipPlugin = 1
	g.omni_sql_no_default_maps = 1
	g.python3_host_prog = "/usr/bin/python3"
	g.matchup_matchparen_offscreen = { method = "popup" }
	g["conjure#eval#result_register"] = "*"
	g["conjure#log#botright"] = true
	g["conjure#mapping#doc_word"] = "gk"
end

local function set_options()
	local o = vim.o

	o.laststatus = 3
	o.backup = false
	o.breakindent = true
	o.completeopt = "menu,menuone,noinsert"
	o.formatoptions = "1jql"
	o.grepformat = "%f:%l:%c:%m"
	o.grepprg = "rg --hidden --vimgrep --smart-case --"
	o.history = 1000
	o.ignorecase = true
	o.inccommand = "nosplit"
	o.jumpoptions = "stack"
	o.lazyredraw = true
	o.listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←"
	o.list = true
	o.maxmempattern = 100000
	o.mouse = "a"
	o.number = true
	o.relativenumber = true
	o.pumheight = 16
	o.redrawtime = 8000
	o.scrolloff = 3
	o.shiftround = true
	o.shiftwidth = 4
	o.shortmess = "aoOTIcF"
	o.showbreak = "↳ "
	o.showmode = false
	o.sidescroll = 5
	o.signcolumn = "yes:1"
	o.smartcase = true
	o.softtabstop = 4
	o.spelllang = "en_gb"
	o.splitbelow = true
	o.splitright = true
	o.scrollsplit = false
	o.synmaxcol = 120
	o.tabstop = 4
	o.termguicolors = true
	o.textwidth = 80
	o.timeoutlen = 500
	o.ttimeoutlen = 10
	o.undodir = "/tmp"
	o.undofile = true
	o.updatetime = 200
	o.wildignorecase = true
	o.wildignore = ".git,*.tags,tags,*.o,**/node_modules/**"
	o.wildmode = "longest:full,full"
	o.writebackup = false
end

local function set_keymaps()
	vim.g.mapleader = " "
	vim.g.maplocalleader = "\\"

	-- leader mappings
	lmap("u", ":PackerUpdate<cr>")
	lmap(";", ":w<cr>")
	lmap("[", "myO<esc>`y")
	lmap("]", "myo<esc>`y")
	lmap("1", "<cmd>ToggleTerm1<cr>")
	lmap("2", "<cmd>ToggleTerm2<cr>")
	lmap("3", "<cmd>ToggleTerm3<cr>")
	lmap("4", "<cmd>ToggleTerm4<cr>")
	lmap("'", "<cmd>ToggleTerm<cr>")
	lmap("y", '"+y')
	lmap("ft", require("moonlight.autoformat").toggle_formatting)

	lmap("se", "<cmd>SqlsExecuteQuery<cr>")
	lmap("sc", "<cmd>SqlsSwitchConnection<cr>")
	lmap("sd", "<cmd>SqlsSwitchDatabase<cr>")
	lmap("sv", "<cmd>SqlsExecuteQueryVertical<cr>")

	-- normal mode
	nmap("^", "0")
	nmap("0", "^")
	nmap("<c-c>", "<esc>")
	nmap("'", "`")
	nmap("`", "'")
	nmap("<c-n>", "<cmd>Neotree reveal toggle<cr>")
	nmap("gs", "<cmd>Neotree git_status<cr>")
	nmap("k", '(v:count > 5 ? "m\'" . v:count : "") . "gk"', { expr = true })
	nmap("j", '(v:count > 5 ? "m\'" . v:count : "") . "gj"', { expr = true })
	nmap("<m-j>", "mz:m+<cr>`z")
	nmap("<m-k>", "mz:m-2<cr>`z")
	nmap("\\", "<cmd>noh<cr><esc>")
	nmap("[b", "<cmd>bprev<cr>")
	nmap("]b", "<cmd>bnext<cr>")
	nmap("[q", "<cmd>cprev<cr>zz")
	nmap("]q", "<cmd>cnext<cr>zz")
	nmap("[<space>", "myO<esc>`y")
	nmap("]<space>", "myo<esc>`y")
	nmap("<localleader>cc", "<cmd>ClojureConnect<cr>")
	nmap("<c-p>", "<c-^>")

	-- telescope
	lmap("<space>", "<cmd>Telescope find_files hidden=true follow=true<cr>")
	lmap("ff", "<cmd>Telescope find_files hidden=true follow=true<cr>")
	lmap("lg", "<cmd>Telescope live_grep<cr>")
	lmap("fb", "<cmd>Telescope buffers<cr>")
	lmap("b", "<cmd>Telescope buffers<cr>")
	lmap("fh", "<cmd>Telescope oldfiles<cr>")
	lmap("fq", "<cmd>Telescope quickfix<cr>")
	lmap("fr", "<cmd>Telescope lsp_references<cr>")
	lmap("ca", "<cmd>Telescope lsp_code_actionsr>")
	lmap("fd", "<cmd>Telescope lsp_definitions<cr>")
	lmap("fi", "<cmd>Telescope lsp_implementations<cr>")
	lmap("f;", "<cmd>Telescope lsp_range_code_actionsr>")
	lmap("fs", "<cmd>Telescope grep_string<cr>")
	lmap("fn", "<cmd>Telescope search_history<cr>")
	lmap("d", "<cmd>lua MiniBufremove.delete()<cr>")
	lmap("m", "mA")

	-- insert mode
	imap("<c-c>", "<esc>")
	imap("<c-d>", "<del>")
	imap("<c-b>", "<left>")
	imap("<c-f>", "<right>")
	imap(",", ",<c-g>u")
	imap(".", ".<c-g>u")
	imap("!", "!<c-g>u")
	imap("?", "?<c-g>u")

	-- visual mode
	vmap("<leader>ss", "!sort -d -b -f <cr>")
	vmap("<leader>y", '"+y')
	vmap("<c-c>", "<esc>")

	-- terminal mode
	tmap("<c-q>", "<c-\\><c-n>")

	-- command mode
	cmap("<c-b>", "<left>")
	cmap("<c-f>", "<right>")
	cmap("<c-a>", "<home>")
	cmap("<c-e>", "<end>")
	cmap("<c-d>", "<del>")
end

function M.setup()
	set_globals()
	set_options()
	set_keymaps()
end

return M
