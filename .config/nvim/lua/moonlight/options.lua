local utils = require("moonlight.utils")

local nmap = utils.nmap
local tmap = utils.tmap
local vmap = utils.vmap
local cmap = utils.cmap
local lmap = utils.lmap
local imap = utils.imap

local function assign_options(option_table, target)
	for key, value in pairs(option_table) do
		target[key] = value
	end
end

assign_options({
	loaded_2html_plugin = 1,
	loaded_getscript = 1,
	loaded_getscriptPlugin = 1,
	loaded_gzip = 1,
	loaded_logiPat = 1,
	loaded_matchit = 1,
	loaded_matchparen = 1,
	loaded_netrw = 1,
	loaded_netrwPlugin = 1,
	loaded_perl_provider = 0,
	loaded_python_provider = 0,
	loaded_rrhelper = 1,
	loaded_ruby_provider = 0,
	loaded_tar = 1,
	loaded_tarPlugin = 1,
	loaded_vimball = 1,
	loaded_vimballPlugin = 1,
	loaded_zip = 1,
	loaded_zipPlugin = 1,
	omni_sql_no_default_maps = 1,
	python3_host_prog = "/usr/bin/python3",
	matchup_matchparen_offscreen = { method = "popup" },
	["conjure#eval#result_register"] = "*",
	["conjure#log#botright"] = true,
	["conjure#mapping#doc_word"] = "gk",
	mapleader = " ",
	maplocalleader = "\\",
}, vim.g)

assign_options({
	backup = false,
	breakindent = true,
	completeopt = "menu,menuone,noinsert",
	formatoptions = "1jql",
	grepformat = "%f:%l:%c:%m",
	grepprg = "rg --hidden --vimgrep --smart-case --",
	history = 1000,
	ignorecase = true,
	inccommand = "nosplit",
	jumpoptions = "stack",
	laststatus = 3,
	lazyredraw = true,
	listchars = "tab:  ,trail:·,extends:…,precedes:…,space: ",
	list = true,
	maxmempattern = 100000,
	mouse = "a",
	number = true,
	pumheight = 16,
	redrawtime = 8000,
	relativenumber = true,
	scrolloff = 3,
	shiftround = true,
	shiftwidth = 4,
	shortmess = "aoOTIcF",
	showbreak = "↳ ",
	showmode = false,
	sidescroll = 5,
	signcolumn = "yes:1",
	smartcase = true,
	softtabstop = 4,
	spelllang = "en_gb",
	splitbelow = true,
	splitright = true,
	synmaxcol = 120,
	tabstop = 4,
	termguicolors = true,
	textwidth = 80,
	timeoutlen = 500,
	ttimeoutlen = 10,
	undodir = "/tmp",
	undofile = true,
	updatetime = 200,
	wildignorecase = true,
	wildignore = ".git,*.tags,tags,*.o,**/node_modules/**",
	wildmode = "longest:full,full",
	writebackup = false,
}, vim.opt)

-- leader mappings
lmap("u", ":PackerUpdate<cr>")
lmap(";", ":w<cr>")
lmap("y", '"+y')
lmap("ft", require("moonlight.autoformat").toggle_formatting)
lmap("ss", "<cmd>SqlsShowDatabases<cr>")
lmap("se", "<cmd>SqlsExecuteQuery<cr>")
lmap("sh", "<cmd>SqlsShowSchemas<cr>")
lmap("sc", "<cmd>SqlsShowConnections<cr>")
lmap("sd", "<cmd>SqlsSwitchDatabase<cr>")
lmap("sx", "<cmd>SqlsSwitchConnection<cr>")
lmap("rr", "<Plug>RestNvim<cr>")
lmap("rp", "<Plug>RestNvimPreview<cr>")
lmap("rl", "<Plug>RestNvimLast<cr>")
lmap("64d", "!!b64d<cr>")
lmap("64e", "!!base64<cr>")

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
nmap("<localleader>cc", "<cmd>ClojureConnect<cr>")
nmap("<c-p>", "<c-^>")
nmap("<c-\\>", function()
	utils.safe_require("FTerm").toggle()
end)

-- telescope
lmap("<space>", "<cmd>Telescope find_files hidden=true follow=true<cr>")
lmap("ff", "<cmd>Telescope find_files hidden=true follow=true<cr>")
lmap("lg", "<cmd>Telescope live_grep<cr>")
lmap("fb", "<cmd>Telescope buffers<cr>")
lmap("b", "<cmd>Telescope buffers<cr>")
lmap("fh", "<cmd>Telescope oldfiles<cr>")
lmap("fq", "<cmd>Telescope quickfix<cr>")
lmap("fr", "<cmd>Telescope lsp_references<cr>")
lmap("fd", "<cmd>Telescope lsp_definitions<cr>")
lmap("fi", "<cmd>Telescope lsp_implementations<cr>")
lmap("fs", "<cmd>Telescope grep_string<cr>")
lmap("fn", "<cmd>Telescope search_history<cr>")
lmap("sb", "<cmd>Telescope symbols<cr>")
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
vmap("<leader>fs", "!sqlformat.sh <cr>")

-- terminal mode
tmap("<c-\\>", function()
	utils.safe_require("FTerm").close({ bang = true })
end)

-- command mode
cmap("<c-b>", "<left>")
cmap("<c-f>", "<right>")
cmap("<c-a>", "<home>")
cmap("<c-e>", "<end>")
cmap("<c-d>", "<del>")
