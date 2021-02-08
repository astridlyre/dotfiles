" ================= looks and GUI stuff ================== "
call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'bluz71/vim-moonfly-colors'

" ================= Functionalities ================= "
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-sandwich'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'jiangmiao/auto-pairs'
Plug 'antoinemadec/FixCursorHold.nvim'
call plug#end()

" ==================== Treesitter ======================== "
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<M-w>',
      node_incremental = '<M-w>',
      scope_incremental = '<M-e>',
      node_decremental = '<M-C-w>',
    },
  },
}
EOF

" ===== statusline =====
set statusline=
set statusline+=\ %#MoonflyEmerald#%t
set statusline+=%=
set statusline+=\ %#MoonflyGrey246#%m
set statusline+=\ %#MoonflyGrey241#%y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %p%%\ 

" ==================== general config ======================== "
set termguicolors
set mouse=a
set tabstop=2 softtabstop=2 shiftwidth=2 autoindent
set expandtab
set incsearch ignorecase smartcase hlsearch " highlight text while searching
set list listchars=trail:»,tab:»- " use tab to navigate in list mode
set wrap breakindent " wrap long lines to the width set by tw
set number
set relativenumber
set showtabline=0
set noshowmode
set noshowcmd
set conceallevel=2 " set this so we wont break indentation plugin
set splitright
set splitbelow
set tw=90 " auto wrap lines that are longer than that
set emoji
set history=1000
set undofile
set undodir=/tmp
set foldlevel=0
set inccommand=nosplit
set grepprg=rg\ --vimgrep " use rg as default grepper

" ===== performance tweaks =====
set nocursorline
set nocursorcolumn
set scrolljump=5
set lazyredraw
set redrawtime=10000
set synmaxcol=180
set timeoutlen=850
set maxmempattern=20000
set re=1
set hidden
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=100
set shortmess+=actI
set signcolumn=yes

" ======================== Plugin Configurations ======================== "
let loaded_netrw = 0
let g:loaded_python_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:python3_host_prog = '/usr/bin/python3'

"colorscheme config should be put before colorscheme
let g:moonflyTransparent = 1
colorscheme moonfly

" indentLine
let g:indentLine_char_list = ['▏', '¦', '┆', '┊']
let g:indentLine_setColors = 0
let g:indentLine_setConceal = 0

" FZF
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }
let g:fzf_tags_command = 'ctags -R'
let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' --glob '!build/**' --glob '!node_modules/**' --glob '!vendor/bundle/**'"

" Fix CursorHold
let g:cursorhold_updatetime = 100

" ======================== Commands ============================= "
au BufEnter * set fo-=c fo-=r fo-=o
au FileType help wincmd L

" enable spell only if file type is normal text
let spellable = ['markdown', 'gitcommit', 'txt', 'text', 'liquid', 'rst']
autocmd BufEnter * if index(spellable, &ft) < 0 | set nospell | else | set spell | endif

" highlight yanked text
augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=350}
augroup END

" fzf if passed argument is a folder
augroup folderarg
    " change working directory to passed directory
    autocmd VimEnter * if argc() != 0 && isdirectory(argv()[0]) | execute 'cd' fnameescape(argv()[0])  | endif
    " start fzf on passed directory
    autocmd VimEnter * if argc() != 0 && isdirectory(argv()[0]) | execute 'Files ' fnameescape(argv()[0]) | endif
augroup END

" files in fzf
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--inline-info']}), <bang>0)

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" advanced grep
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

" ================== Custom Functions ===================== "
" advanced grep(faster with preview)
function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

" Temporary fix for when treesitter highlight goes wonky
function! ResetHightlight()
  execute 'write | edit | TSBufEnable highlight'
endfunction

" ======================== Custom Mappings ====================== "

" ===== Leader =====
let mapleader=' '
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pu :PlugUpdate<CR>
nnoremap <leader>\ :qa!<CR>
nnoremap <leader>q :bd<CR>
nnoremap <leader>r :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>t :call ResetHightlight()<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>z :bd!<CR>
" new line in normal mode and back
nnoremap <leader>[ myO<ESC>`y
nnoremap <leader>] myo<ESC>`y
" open a terminal
nnoremap <leader>' :sp term://bash<CR>i
"" FZF
nnoremap <leader>bb :Buffers<CR>
nnoremap <leader>bt :BTags<CR>
nnoremap <leader>: :Commands<CR>
nnoremap <leader>gc :Commits<CR>
nnoremap <leader>gs :GFiles?<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>/ :Rg<CR>
nnoremap <silent> <leader>f :Files<CR>
" easy system clipboard copy & paste
nnoremap <leader>p "+p
nnoremap <leader>Y mqgg"+yG`q
nnoremap <leader>y "+y
vnoremap <leader>p "+p
vnoremap <leader>Y "+Y
vnoremap <leader>y "+y

" ===== Global =====
map Y y$
map <F3> :e ~/.config/nvim/init.vim<CR>

" ===== Normal mode =====
nmap s <Nop>
nmap <F1> <plug>(fzf-maps-n)
" easy buffer switch
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
" easy move line with alt+j/k
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z
" disable hl with 2 esc
noremap <silent><esc> <esc>:noh<CR><esc>
nnoremap <F2> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" ===== Insert mode =====
inoremap jk <ESC>
imap <F1> <plug>(fzf-maps-i)

" ===== Visual mode =====
vmap <F1> <plug>(fzf-maps-x)
" easier move line with alt+j/k
vnoremap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" ===== Command mode =====
cnoremap jk <ESC>
cnoremap <c-n>  <down>
cnoremap <c-p>  <up>

" ===== Terminal mode =====
tnoremap <Esc> <C-\><C-n><C-w>q
tnoremap jk <C-\><C-n>
