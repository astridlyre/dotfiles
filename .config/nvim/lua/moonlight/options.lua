local utils = require("moonlight.utils")

local nmap = utils.nmap
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
	mapleader = " ",
	maplocalleader = "\\",
	markdown_recommende_style = 0,
	matchup_matchparen_offscreen = { method = "popup" },
	omni_sql_no_default_maps = 1,
	python3_host_prog = "/usr/bin/python3",
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
	winminwidth = 5,
	writebackup = false,
}, vim.opt)

-- leader mappings
lmap("u", "<cmd>Lazy update<cr>")
lmap(";", ":w<cr>")
lmap("y", '"+y')
lmap("ft", require("moonlight.autoformat").toggle_formatting)
lmap("64d", "!!b64d<cr>")
lmap("64e", "!!base64<cr>")
lmap("ct", "<cmd>ColorizerToggle<cr>")

-- normal mode
nmap("^", "0")
nmap("0", "^")
nmap("<c-c>", "<esc>")
nmap("'", "`")
nmap("`", "'")
nmap("k", '(v:count > 5 ? "m\'" . v:count : "") . "gk"', { expr = true })
nmap("j", '(v:count > 5 ? "m\'" . v:count : "") . "gj"', { expr = true })
nmap("<m-j>", "mz:m+<cr>`z")
nmap("<m-k>", "mz:m-2<cr>`z")
nmap("<esc>", "<cmd>noh<cr><esc>")
nmap("[b", "<cmd>bprev<cr>")
nmap("]b", "<cmd>bnext<cr>")
nmap("[q", "<cmd>cprev<cr>zz")
nmap("]q", "<cmd>cnext<cr>zz")
nmap("<c-p>", "<c-^>")
nmap("<c-h>", "<c-^>")

-- toggle quickfix
vim.g.qfix_win = nil
local function toggle_qf_list()
	if vim.g.qfix_win ~= nil then
		vim.cmd("cclose")
		vim.g.qfix_win = nil
	else
		vim.cmd("copen")
	end
end

nmap("<c-q>", toggle_qf_list)

-- telescope
nmap("<c-n>", function()
	require("telescope").extensions.file_browser.file_browser()
end)
lmap("o", "<cmd>Telescope find_files hidden=true follow=true<cr>")
lmap("lg", "<cmd>Telescope live_grep<cr>")
lmap("fb", "<cmd>Telescope buffers<cr>")
lmap("fo", "<cmd>Telescope current_buffer_fuzzy_find<cr>")
lmap("fh", "<cmd>Telescope oldfiles<cr>")
lmap("fqq", "<cmd>Telescope quickfix<cr>")
lmap("fqh", "<cmd>Telescope quickfixhistory<cr>")
lmap("fr", "<cmd>Telescope lsp_references<cr>")
lmap("fd", "<cmd>Telescope lsp_definitions<cr>")
lmap("fi", "<cmd>Telescope lsp_implementations<cr>")
lmap("fs", "<cmd>Telescope grep_string<cr>")
lmap("fn", "<cmd>Telescope search_history<cr>")
lmap("fc", "<cmd>Telescope command_history<cr>")
lmap("fm", "<cmd>Telescope man_pages<cr>")
lmap("fj", "<cmd>Telescope jumplist<cr>")
lmap("ls", "<cmd>Telescope lsp_document_symbols<cr>")
lmap("lS", "<cmd>Telescope lsp_workspace_symbols<cr>")
lmap("fd", "<cmd>Telescope diagnostics<cr>")
lmap("d", "<cmd>lua MiniBufremove.delete()<cr>")
lmap("sj", "<cmd>%!sql_to_json<cr>")
lmap("sc", "<cmd>%!sql_to_csv<cr>")
lmap("co", "<cmd>Telescope git_branches<cr>")
lmap("gs", "<cmd>Telescope git_status<cr>")
lmap("ga", "<cmd>Gitsigns stage_buffer<cr>")
lmap("gh", "<cmd>Gitsigns stage_hunk<cr>")
lmap("gH", "<cmd>Gitsigns undo_stage_hunk<cr>")
lmap("gR", "<cmd>Gitsigns reset_buffer<cr>")

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
vmap("<leader>sj", "!sql_to_json<cr>")
vmap("<leader>sc", "!sql_to_csv<cr>")

-- command mode
cmap("<c-b>", "<left>")
cmap("<c-f>", "<right>")
cmap("<c-a>", "<home>")
cmap("<c-e>", "<end>")
cmap("<c-d>", "<del>")

local function augroup(name)
	return vim.api.nvim_create_augroup("moonlight_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = augroup("qfixtoggle"),
	callback = function()
		vim.g.qfix_win = vim.api.nvim_get_current_buf()
	end,
})

vim.cmd([[
iabbr improt import
iabbr funciton function
iabbr exprot export
iabbr expotr export
	]])

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("golang"),
	callback = function()
		if vim.bo.filetype == "go" then
			vim.api.nvim_buf_set_keymap(0, "i", ";;", ":=", { silent = true })
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("noqfixlisted"),
	callback = function()
		if vim.bo.filetype == "qf" then
			vim.bo.buflisted = false
		end
	end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
	group = augroup("cursorline"),
	callback = function()
		if not vim.wo.cursorline and vim.fn.win_gettype() ~= "popup" and not vim.wo.pvw then
			vim.wo.cursorline = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
	group = augroup("nocursorline"),
	callback = function()
		if vim.wo.cursorline then
			vim.wo.cursorline = false
		end
	end,
})

vim.api.nvim_create_autocmd("VimResized", {
	group = augroup("winresize"),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query", -- :InspectTree
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})
