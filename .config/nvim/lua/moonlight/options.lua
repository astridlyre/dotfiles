local copilot = require("moonlight.copilot")

local function assign(option_table, target)
	for key, value in pairs(option_table) do
		target[key] = value
	end
end

assign({
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

assign({
	backup = false,
	breakindent = true,
	completeopt = "menu,menuone,noinsert",
	exrc = true,
	foldmethod = "manual",
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
	pumheight = 16,
	redrawtime = 8000,
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

assign({
	winborder = "rounded"
}, vim.o)

-- normal mappings
vim.keymap.set('n', "<leader>u", "<cmd>Lazy update<cr>")
vim.keymap.set('n', "<leader>y", '"+y')
vim.keymap.set('n', "<c-c>", "<esc>")
vim.keymap.set('n', "'", "`")
vim.keymap.set('n', "`", "'")
vim.keymap.set('n', "<esc>", "<cmd>noh<cr><esc>")
vim.keymap.set('n', "[b", "<cmd>bprev<cr>")
vim.keymap.set('n', "]b", "<cmd>bnext<cr>")
vim.keymap.set('n', "[q", "<cmd>cprev<cr>zz")
vim.keymap.set('n', "]q", "<cmd>cnext<cr>zz")
vim.keymap.set('n', "<c-h>", "<c-^>")
vim.keymap.set('n', "<leader>fl", "<cmd>!biome lint --fix --unsafe --stdin-file-path=%<cr>")
vim.keymap.set('n', "<leader>ct", copilot.toggle)
vim.keymap.set('n', "<c-q>", function()
	vim.cmd("copen")
end)

-- insert mode
vim.keymap.set('i', "<c-c>", function()
	vim.snippet.stop()
	return "<esc>"
end, { expr = true })

vim.keymap.set('i', "<esc>", function()
	vim.snippet.stop()
	return "<esc>"
end, { expr = true })

-- visual mode
vim.keymap.set("v", "<leader>ss", "!sort -d -b -f <cr>")
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("v", "<c-c>", "<esc>")
vim.keymap.set("v", "<leader>fs", "!sqlformat.sh <cr>")
vim.keymap.set("v", "<leader>fh", "!prettier --parser html <cr>")
vim.keymap.set("v", "<leader>fc", "!prettier --parser css <cr>")
vim.keymap.set("v", "<leader>fg", "!prettier --parser graphql <cr>")
vim.keymap.set("v", "<leader>fj", "!prettier --parser json <cr>")
vim.keymap.set("v", "<leader>fg", "!prettier --parser glimmer <cr>")
vim.keymap.set("v", "<leader>fl", "!biome lint --fix --unsafe --stdin-file-path=%<cr>")

-- Color converter
vim.keymap.set("v", "<leader>cc", function()
	local selection = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
	local handle = io.popen("echo " .. vim.fn.shellescape(selection) .. " | color_convert.sh", "r")
	if not handle then return end
	local output = handle:read("*a")
	handle:close()
	output = output:gsub("\n$", "")
	vim.api.nvim_paste(output, true, -1)
end)

-- command mode
vim.keymap.set('c', "<c-b>", "<left>")
vim.keymap.set('c', "<c-f>", "<right>")
vim.keymap.set('c', "<c-a>", "<home>")
vim.keymap.set('c', "<c-e>", "<end>")
vim.keymap.set('c', "<c-d>", "<del>")


local function augroup(name)
	return vim.api.nvim_create_augroup("moonlight_" .. name, { clear = true })
end

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
		"copilot",
		"help",
		"lspinfo",
		"man",
		"nofile",
		"notify",
		"PlenaryTestPopup",
		"prompt",
		"qf",
		"query", -- :InspectTree
		"spectre_panel",
		"startuptime",
		"terminal",
		"toggleterm",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.api.nvim_buf_set_keymap(event.buf, "n", "q", "<Cmd>close<CR>", { silent = true })
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

vim.filetype.add({ extension = { templ = "templ" } })

vim.api.nvim_create_autocmd('BufEnter', {
	command = "syntax sync fromstart",
	pattern = { '*.ly', '*.ily', '*.tex' }
})
