" ================= Auto Install Plug ================== "
" if empty(glob('~/.config/nvim/autoload/plug.vim'))
"   silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif

" ================= Plugins ================== "
call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'fenetikm/falcon'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }         " fzf itself
Plug 'junegunn/fzf.vim'                                     " fuzzy search integration
Plug 'junegunn/vim-easy-align'                              " Easy align
Plug 'honza/vim-snippets'                                   " actual snippets
Plug 'tpope/vim-commentary'                                 " better commenting
Plug 'tpope/vim-fugitive'                                   " git support
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Syntax support
Plug 'jiangmiao/auto-pairs'                                 " Auto bracket pairs
Plug 'neovim/nvim-lspconfig'                                " LSP configs
Plug 'hrsh7th/nvim-compe'                                   " Autocompletion
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }          " Go lang plugin
call plug#end()

" ==================== Lua Stuff ======================== "

lua require('config')

" ==================== statusline ======================== "
set statusline=                                                               " Clear default statusline
set statusline+=\ ❱\ %t                                       " Filename
set statusline+=%=                                                            " Spacer
set statusline+=\ %m                                       " Modified symbol
set statusline+=\ %y                                        " Filetype
set statusline+=\ %{&fileencoding?&fileencoding:&encoding} " Encoding
set statusline+=\ %p%%\                                                       " Percent

" ==================== general config ======================== "
set number relativenumber                           " Line numbers and relative numbers
set termguicolors                                   " True colors
set mouse=a                                         " Enable mouse scroll
set foldmethod=manual                               " Manual folding only
set tabstop=2 softtabstop=2 shiftwidth=2 autoindent " tab width
set expandtab
set ignorecase smartcase                            " highlight text while searching
set list listchars=trail:»,tab:»-                   " use tab to navigate in list mode
set wrap breakindent                                " wrap long lines to the width set by tw
set showtabline=0                                   " Never show tabline
set noshowmode                                      " Do not show mode under statusline
set splitright splitbelow                           " Splits 
set tw=80                                           " auto wrap lines
set history=1000                                    " history limit
set undofile undodir=/tmp                           " enable persistent undo
set inccommand=nosplit                              " visual feedback while substituting
set grepprg=rg\ --vimgrep                           " use rg as default grepper
set wildmode=longest:full,full
set wildignorecase
set wildignore=*.git/*,*.tags,tags,*.o,*.class,*.ccls-cache,*/node_modules/*
set re=1
set hidden                                          " Keep buffers around
set nobackup nowritebackup                          " Do not make backup files
set cmdheight=1                                     " Make hight 1 line
set updatetime=100                                  " For CursorHold autocmd
set shortmess+=actI                                 " Avoid more press enters
set signcolumn=yes                                  " Always show signcolumn
set spelllang=en_gb                                 " Canadian spelling

" ==================== performance tweaks ======================== "
set nocursorline nocursorcolumn                     " Do not show cursorline or colum
set scrolljump=3 scrolloff=3                        " Keep cursor 5 lines from edges
set lazyredraw                                      " Performance boost for macros
set redrawtime=10000                                " Allow more time for redraws
set synmaxcol=180                                   " No syntax on long lines
set timeoutlen=850                                  " Time to wait between keypress
set maxmempattern=100000                            " Max mem to use
set completeopt=menuone,noselect                    " Default complete opt
set pumheight=20                                    " Max 20 items at once

" ======================== Plugin Configurations ======================== "
let g:loaded_gzip              = 1                  " Disable Unused plugins
let g:loaded_tarPlugin         = 1
let g:loaded_zipPlugin         = 1
let g:loaded_2html_plugin      = 1
let g:loaded_rrhelper          = 1
let g:loaded_remote_plugins    = 1
let g:loaded_netrw             = 1                  " Disable netrw
let g:loaded_netrwPlugin       = 1
let g:omni_sql_no_default_maps = 1                  " disable sql omni completion
let g:loaded_python_provider   = 0                  " Disable python2
let g:loaded_perl_provider     = 0                  " Disable perl
let g:loaded_ruby_provider     = 0                  " Disable ruby
let g:python3_host_prog        = '/usr/bin/python3' " Default python3

" Colorscheme
let g:falcon_lightline = 1
let g:lightline = { 'colorscheme': 'falcon' }
colorscheme falcon

" For quickfix / location list toggle
let g:moonlight_qf_g = 0
let g:moonlight_qf_l = 0
let g:autoFormat = 1

" FZF
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }
let g:fzf_tags_command = 'ctags -R'
let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' --glob '!build/**' --glob '!node_modules/**' --glob '!vendor/bundle/**'"

" vim-go
let g:go_fmt_autosave = 1
let g:go_fmt_command  = "goimports"

" lorem ipsum
iab <expr> lorem system('curl -s http://metaphorpsum.com/paragraphs/1')

" ======================== Commands ============================= "
au BufEnter * set fo-=c fo-=r fo-=o " stop annoying auto commenting on new lines
au FileType help wincmd L           " open help in vertical split

" No line numbers or relative numbers in terminal window
augroup TerminalEnter
  autocmd!
  au TermOpen * setlocal nonumber
  au TermOpen * setlocal norelativenumber
augroup end

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
  autocmd VimEnter * if argc() != 0 && isdirectory(argv()[0]) | execute 'cd' fnameescape(argv()[0])  | endif
  autocmd VimEnter * if argc() != 0 && isdirectory(argv()[0]) | execute 'Files ' fnameescape(argv()[0]) | endif
augroup END

" files in fzf
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--inline-info']}), <bang>0)

" Return to last edit position when opening files
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Autoformat on save
let autoFormatable = ['markdown', 'sh', 'bash', 'python', 'javascript', 'rust',
      \ 'go', 'yaml', 'html', 'css', 'json', 'lua', 'c', 'typescript']
autocmd BufWritePost * if index(autoFormatable, &ft) >= 0 && g:autoFormat == 1
      \ | exe 'lua vim.lsp.buf.formatting()' | endif

" advanced grep
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

" Strip whitespace
command! StripWhitespace :%s/\s\+$//e

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

fun! ToggleAutoFormat()
  if g:autoFormat == 1 | let g:autoFormat = 0 | echo "Autoformatting disabled"
  else | let g:autoFormat = 1 | echo "Autoformatting enabled" | end
endfun

" Toggle quickfix
fun! ToggleQFList(global)
  if a:global == 1
    if g:moonlight_qf_g == 1 | let g:moonlight_qf_g = 0 | cclose | else
      let g:moonlight_qf_g = 1 | copen | end
  else
    if g:moonlight_qf_l == 1 | let g:moonlight_qf_l = 0 | lclose | else
      let g:moonlight_qf_l = 1 | lopen | end
  end
endfun

" =================== Global Mappings ==========================
" Disable s and make y consistent
nmap s <Nop>
map Y y$

" =================== Leader Mappings ==========================
" Map leader to space
let mapleader=' '

" Edit configs
nnoremap <leader>ee :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>el :e ~/.config/nvim/lua/config.lua<CR>

" Install or Update Plugins <leader>p*
nnoremap <leader>ui :PlugInstall<CR>
nnoremap <leader>uu :PlugUpdate<CR>

" Misc helper things <leader>?
nnoremap <leader>r :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>e :call ResetHightlight()<CR>
nnoremap <leader>; :w<CR>
nnoremap <leader>\ :qa!<CR>
nnoremap <leader>q :call ToggleQFList(0)<CR>
nnoremap <leader>j :lnext<CR>zz
nnoremap <leader>k :lprev<CR>zz
nnoremap <leader>af :call ToggleAutoFormat()<CR>

" new line in normal mode and back
nnoremap <leader>[ myO<ESC>`y
nnoremap <leader>] myo<ESC>`y

" open terminal
nnoremap <leader>' :sp term://bash<CR>i

" lil scripties <leader>s*
vnoremap <leader>ss !sort -d -b -f<CR>
vnoremap <leader>sc !scriptbc<CR>
nnoremap <leader>sw :StripWhitespace<CR>

" easy system clipboard copy & paste
nnoremap <leader>Y mqgg"+yG`q
nnoremap <leader>cp "+p
nnoremap <leader>y "+y
vnoremap <leader>Y "+Y
vnoremap <leader>cp "+p
vnoremap <leader>y "+y

" FZF <leader>f*
nmap <leader>fr :Rg<CR>
nmap <leader>f: :Commands<CR>
nmap <leader>fb :Buffers<CR>
nmap <leader>ft :BTags<CR>
nmap <leader>fc :Commits<CR>
nmap <leader>fg :GFiles?<CR>
nmap <leader>fh :History<CR>
nmap <leader>ff :Files<CR>

" fugitive mappings <leader>g[bd]
nmap <leader>gb :Git blame<CR>
nmap <leader>gd :Gdiffsplit<CR>

" vim-go mappings <leader>g*
nmap <leader>ga :GoAlternate<CR>
nmap <leader>gc :GoCoverageToggle<CR>
nmap <leader>ge :GoIfErr<CR>
nmap <leader>gi :GoImports<CR>
nmap <leader>gl :GoMetaLint<CR>
nmap <leader>gr :GoRun<CR>
nmap <leader>gs :GoFillStruct<CR>
nmap <leader>gt :GoTest<CR>

" vim-easy-align <leader>a
xmap <leader>a <Plug>(EasyAlign)
nmap <leader>a <Plug>(EasyAlign)

" =================== Normal Mappings ==========================
" Easier move line with alt+j / alt+k
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprev<CR>
nnoremap <C-q> :call ToggleQFList(1)<CR>
nnoremap <C-j> :cnext<CR>zz
nnoremap <C-k> :cprev<CR>zz

" Disable hl with 2 esc
noremap <silent><esc><esc> :noh<CR><esc>

" =================== Visual Mappings ==========================
" Easier move line with alt+j / alt+k
vnoremap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" =================== Insert Mappings ==========================
inoremap <silent><expr> <C-e> compe#close('<C-e>')
inoremap <silent><expr> <C-y> compe#confirm('<C-y>')
inoremap <silent><expr> <CR> pumvisible() ? compe#confirm('<C-y><CR>') : "\<CR>"
