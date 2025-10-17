(local vim _G.vim)

;; Variables
(set vim.g.mapleader " ")
(set vim.g.maplocalleader ",")
(set vim.g.omni_sql_no_default_maps 1)
(set vim.g.python3_host_prog :/usr/bin/python3)

;; Options
(set vim.o.backup false)
(set vim.o.breakindent true)
(set vim.o.completeopt "menu,menuone,noinsert")
(set vim.o.exrc true)
(set vim.o.foldmethod :manual)
(set vim.o.formatoptions :1jql)
(set vim.o.grepformat "%f:%l:%c:%m")
(set vim.o.grepprg "rg --hidden --vimgrep --smart-case --")
(set vim.o.history 1000)
(set vim.o.ignorecase true)
(set vim.o.inccommand :nosplit)
(set vim.o.jumpoptions :stack)
(set vim.o.laststatus 3)
(set vim.o.lazyredraw true)
(set vim.o.listchars "tab:  ,trail:·,extends:…,precedes:…,space: ")
(set vim.o.list true)
(set vim.o.maxmempattern 100000)
(set vim.o.mouse :a)
(set vim.o.pumheight 16)
(set vim.o.redrawtime 8000)
(set vim.o.scrolloff 3)
(set vim.o.shiftround true)
(set vim.o.shiftwidth 4)
(set vim.o.shortmess :aoOTIcF)
(set vim.o.showbreak "↳ ")
(set vim.o.showmode false)
(set vim.o.sidescroll 5)
(set vim.o.signcolumn "yes:1")
(set vim.o.smartcase true)
(set vim.o.softtabstop 4)
(set vim.o.spelllang :en_gb)
(set vim.o.splitbelow true)
(set vim.o.splitright true)
(set vim.o.synmaxcol 120)
(set vim.o.tabstop 4)
(set vim.o.termguicolors true)
(set vim.o.textwidth 80)
(set vim.o.timeoutlen 500)
(set vim.o.ttimeoutlen 10)
(set vim.o.undodir :/tmp)
(set vim.o.undofile true)
(set vim.o.updatetime 200)
(set vim.o.wildignorecase true)
(set vim.o.wildignore ".git,*.tags,tags,*.o,**/node_modules/**")
(set vim.o.wildmode "longest:full,full")
(set vim.o.winminwidth 5)
(set vim.o.writebackup false)
(set vim.o.winborder :rounded)

(local copilot (require :moonlight.copilot))

(local kmap vim.keymap.set)

;; Mappings
(kmap :n :<leader>u "<cmd>Lazy update<cr>" {:desc "Update plugins"})
(kmap :n :<leader>y "\"+y" {:desc "Yank to system clipboard"})
(kmap :n :<c-c> :<esc> {:desc :Escape})
(kmap :n "'" "`" {:desc "Jump to mark"})
(kmap :n "`" "'" {:desc "Jump to mark"})
(kmap :n :<esc> :<cmd>noh<cr><esc> {:desc "Clear search highlight"})
(kmap :n "[b" :<cmd>bprev<cr> {:desc "Previous buffer"})
(kmap :n "]b" :<cmd>bnext<cr> {:desc "Next buffer"})
(kmap :n "[q" :<cmd>cprev<cr>zz {:desc "Previous quickfix"})
(kmap :n "]q" :<cmd>cnext<cr>zz {:desc "Next quickfix"})
(kmap :n :<c-h> :<c-^> {:desc "Switch to alternate file"})
(kmap :n :<leader>fl "<cmd>!biome lint --fix --unsafe --stdin-file-path=%<cr>"
      {:desc "Fix current file with Biome"})

(kmap :n :<leader>ct copilot.toggle-copilot {:desc "Toggle GitHub Copilot"})
(kmap :n :<c-q> (fn [] (vim.cmd :copen)) {:desc "Open quickfix"})

(kmap :i :<c-c> (fn [] (vim.snippet.stop) :<esc>)
      {:expr true :desc "Escape (End snippet)"})

(kmap :i :<esc> (fn [] (vim.snippet.stop) :<esc>)
      {:expr true :desc "Escape (End snippet)"})

(kmap :v :<leader>ss "!sort -d -b -f <cr>" {:desc "Sort selection"})
(kmap :v :<leader>y "\"+y" {:desc "Yank to system clipboard"})
(kmap :v :<c-c> :<esc> {:desc :Escape})
(kmap :v :<leader>fs "!sqlformat.sh <cr>" {:desc "Format SQL"})
(kmap :v :<leader>fh "!prettier --parser html <cr>" {:desc "Format HTML"})
(kmap :v :<leader>fc "!prettier --parser css <cr>" {:desc "Format CSS"})
(kmap :v :<leader>fg "!prettier --parser graphql <cr>" {:desc "Format GraphQL"})
(kmap :v :<leader>fj "!prettier --parser json <cr>" {:desc "Format JSON"})
(kmap :v :<leader>fl "!biome lint --fix --unsafe --stdin-file-path=%<cr>"
      {:desc "Fix current selection with Biome"})

(fn convert-color []
  "Convert color under cursor/selection to other formats"
  (let [selection (table.concat (vim.fn.getregion (vim.fn.getpos :v)
                                                  (vim.fn.getpos "."))
                                "\n")
        handle (io.popen (.. :echo (vim.fn.shellescape selection)
                             " | color_convert.sh") :r)]
    (when (handle)
      (let [output (handle:read :*a)]
        ((handle:close))
        ((vim.api.nvim_paste (output:gsub "\n$" " ") true -1))))))

;; Convert color under cursor/selection to other formats
(kmap :v :<leader>cc convert-color
      {:desc "Convert selected color from hex to rgb or vice versa"})

(kmap :c :<c-b> :<left> {:desc :Left})
(kmap :c :<c-f> :<right> {:desc :Right})
(kmap :c :<c-a> :<home> {:desc :Home})
(kmap :c :<c-e> :<end> {:desc :End})
(kmap :c :<c-d> :<del> {:desc :Delete})

;; Filetypes
(vim.filetype.add {:extension {:templ :templ}})
