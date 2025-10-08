-- [nfnl] lua/moonlight/options.fnl
local vim = _G.vim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.omni_sql_no_default_maps = 1
vim.g.python3_host_prog = "/usr/bin/python3"
vim.o.backup = false
vim.o.breakindent = true
vim.o.completeopt = "menu,menuone,noinsert"
vim.o.exrc = true
vim.o.foldmethod = "manual"
vim.o.formatoptions = "1jql"
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.grepprg = "rg --hidden --vimgrep --smart-case --"
vim.o.history = 1000
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.jumpoptions = "stack"
vim.o.laststatus = 3
vim.o.lazyredraw = true
vim.o.listchars = "tab:  ,trail:\194\183,extends:\226\128\166,precedes:\226\128\166,space: "
vim.o.list = true
vim.o.maxmempattern = 100000
vim.o.mouse = "a"
vim.o.pumheight = 16
vim.o.redrawtime = 8000
vim.o.scrolloff = 3
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.o.shortmess = "aoOTIcF"
vim.o.showbreak = "\226\134\179 "
vim.o.showmode = false
vim.o.sidescroll = 5
vim.o.signcolumn = "yes:1"
vim.o.smartcase = true
vim.o.softtabstop = 4
vim.o.spelllang = "en_gb"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.synmaxcol = 120
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.textwidth = 80
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10
vim.o.undodir = "/tmp"
vim.o.undofile = true
vim.o.updatetime = 200
vim.o.wildignorecase = true
vim.o.wildignore = ".git,*.tags,tags,*.o,**/node_modules/**"
vim.o.wildmode = "longest:full,full"
vim.o.winminwidth = 5
vim.o.writebackup = false
vim.o.winborder = "rounded"
local copilot = require("moonlight.copilot")
local kmap = vim.keymap.set
kmap("n", "<leader>u", "<cmd>Lazy update<cr>")
kmap("n", "<leader>y", "\"+y")
kmap("n", "<c-c>", "<esc>")
kmap("n", "'", "`")
kmap("n", "`", "'")
kmap("n", "<esc>", "<cmd>noh<cr><esc>")
kmap("n", "[b", "<cmd>bprev<cr>")
kmap("n", "]b", "<cmd>bnext<cr>")
kmap("n", "[q", "<cmd>cprev<cr>zz")
kmap("n", "]q", "<cmd>cnext<cr>zz")
kmap("n", "<c-h>", "<c-^>")
kmap("n", "<leader>fl", "<cmd>!biome lint --fix --unsafe --stdin-file-path=%<cr>")
kmap("n", "<leader>ct", copilot["toggle-copilot"])
local function _1_()
  return vim.cmd("copen")
end
kmap("n", "<c-q>", _1_)
local function _2_()
  vim.snippet.stop()
  return "<esc>"
end
kmap("i", "<c-c>", _2_, {expr = true})
local function _3_()
  vim.snippet.stop()
  return "<esc>"
end
kmap("i", "<esc>", _3_, {expr = true})
kmap("v", "<leader>ss", "!sort -d -b -f <cr>")
kmap("v", "<leader>y", "\"+y")
kmap("v", "<c-c>", "<esc>")
kmap("v", "<leader>fs", "!sqlformat.sh <cr>")
kmap("v", "<leader>fh", "!prettier --parser html <cr>")
kmap("v", "<leader>fc", "!prettier --parser css <cr>")
kmap("v", "<leader>fg", "!prettier --parser graphql <cr>")
kmap("v", "<leader>fj", "!prettier --parser json <cr>")
kmap("v", "<leader>fg", "!prettier --parser glimmer <cr>")
kmap("v", "<leader>fl", "!biome lint --fix --unsafe --stdin-file-path=%<cr>")
local function convert_color()
  local selection = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
  local handle = io.popen(("echo" .. vim.fn.shellescape(selection) .. " | color_convert.sh"), "r")
  if handle() then
    local output = handle:read("*a")
    handle:close()()
    return vim.api.nvim_paste(output:gsub("\n$", " "), true, -1)()
  else
    return nil
  end
end
kmap("v", "<leader>cc", convert_color)
kmap("c", "<c-b>", "<left>")
kmap("c", "<c-f>", "<right>")
kmap("c", "<c-a>", "<home>")
kmap("c", "<c-e>", "<end>")
kmap("c", "<c-d>", "<del>")
return vim.filetype.add({extension = {templ = "templ"}})
