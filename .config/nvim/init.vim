" if empty(glob('~/.config/nvim/autoload/plug.vim'))
"   silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif
" ================= looks and GUI stuff ================== "
call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'bluz71/vim-moonfly-colors'

" ================= Functionalities ================= "
Plug 'neoclide/coc.nvim', {'branch': 'release'}              " LSP and more
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }          " fzf itself
Plug 'junegunn/fzf.vim'                                      " fuzzy search integration
Plug 'SirVer/ultisnips'                                      " snippets manager
Plug 'honza/vim-snippets'                                    " actual snippets
Plug 'Yggdroot/indentLine'                                   " show indentation lines
Plug 'tpope/vim-commentary'                                  " better commenting
Plug 'tpope/vim-fugitive'                                    " git support
Plug 'machakann/vim-sandwich'                                " make sandwiches
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'jiangmiao/auto-pairs'                                  " Auto bracket pairs
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
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

" statusline
set statusline=
set statusline+=\ %#MoonflyEmerald#%t
set statusline+=%=
set statusline+=\ %#MoonflyGrey246#%m
set statusline+=\ %#MoonflyGrey241#%y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %p%%\ 

" ==================== general config ======================== "
set termguicolors                                       " Opaque Background
set mouse=a                                             " enable mouse scrolling
set tabstop=2 softtabstop=2 shiftwidth=2 autoindent     " tab width
set expandtab                                           " tab key actions
set incsearch ignorecase smartcase hlsearch             " highlight text while searching
set list listchars=trail:»,tab:»-                       " use tab to navigate in list mode
set wrap breakindent                                    " wrap long lines to the width set by tw
set number                                              " enable numbers on the left
set relativenumber                                      " current line is 0
set noshowmode                                          " dont show current mode below statusline
set showtabline=0
set noshowcmd                                           " to get rid of display of last command
set conceallevel=2                                      " set this so we wont break indentation plugin
set splitright                                          " open vertical split to the right
set splitbelow                                          " open horizontal split to the bottom
set tw=90                                               " auto wrap lines that are longer than that
set emoji                                               " enable emojis
set history=1000                                        " history limit
set undofile                                            " enable persistent undo
set undodir=/tmp                                        " undo temp file directory
set foldlevel=0                                         " open all folds by default
set inccommand=nosplit                                  " visual feedback while substituting
set grepprg=rg\ --vimgrep                               " use rg as default grepper
" performance tweaks
set nocursorline
set nocursorcolumn
set scrolljump=5
set lazyredraw
set redrawtime=10000
set synmaxcol=180
set timeoutlen=850
set maxmempattern=20000
set re=1
" required by coc
set hidden
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=100
set shortmess+=actI
set signcolumn=yes
" ======================== Plugin Configurations ======================== "
" built in plugins
let loaded_netrw = 0                                    " diable netew
let g:omni_sql_no_default_maps = 1                      " disable sql omni completion
let g:loaded_python_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:python3_host_prog = '/usr/bin/python3'

"colorscheme config should be put before colorscheme
let g:moonflyTransparent = 1
colorscheme moonfly

" coc settings
let g:coc_global_extensions = [
            \'coc-json',
            \'coc-go',
            \'coc-css',
            \'coc-html',
            \'coc-emmet',
            \'coc-tsserver',
            \'coc-yaml',
            \'coc-lists',
            \'coc-clangd',
            \'coc-prettier',
            \'coc-git',
            \'coc-highlight',
            \'coc-sh',
\]

" indentLine
let g:indentLine_char_list = ['▏', '¦', '┆', '┊']
let g:indentLine_setColors = 0
let g:indentLine_setConceal = 0                         " actually fix the annoying markdown links conversion

" FZF
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }
let g:fzf_tags_command = 'ctags -R'
let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' --glob '!build/**' --glob '!node_modules/**' --glob '!vendor/bundle/**'"

" vim-go
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

" Fix CursorHold
let g:cursorhold_updatetime = 100

" ======================== Commands ============================= "
au BufEnter * set fo-=c fo-=r fo-=o                     " stop annoying auto commenting on new lines
au FileType help wincmd L                               " open help in vertical split

" vim-sandwich use simple highlight color
call operator#sandwich#set('all', 'all', 'highlight', 1)

" enable spell only if file type is normal text
let spellable = ['markdown', 'gitcommit', 'txt', 'text', 'liquid', 'rst']
autocmd BufEnter * if index(spellable, &ft) < 0 | set nospell | else | set spell | endif

" highlight yanked text
augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=350}
augroup END

" coc completion popup
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

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

" format with available file format formatter
command! -nargs=0 Format :call CocAction('format')

" organize imports
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

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

" coc documentation
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Temporary fix for when treesitter highlight goes wonky
function! ResetHightlight()
  execute 'write | edit | TSBufEnable highlight'
endfunction

" ======================== Custom Mappings ====================== "
" essentials
let mapleader=' '
nmap s <Nop>
map Y y$
inoremap jk <ESC>
cnoremap jk <ESC>
map <F3> :e ~/.config/nvim/init.vim<CR>
nnoremap <leader>t :call ResetHightlight()<CR>
nnoremap <leader>r :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>q :bd<CR>
nnoremap <leader>z :bd!<CR>
nnoremap <leader>\ :qa!<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>lf :Format<CR>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <leader>pi :PlugInstall<CR>
nnoremap <leader>pu :PlugUpdate<CR>

" easy system clipboard copy & paste
nnoremap <leader>y "+y
nnoremap <leader>Y mqgg"+yG`q
nnoremap <leader>p "+p
vnoremap <leader>y "+y
vnoremap <leader>Y "+Y
vnoremap <leader>p "+p

" easier move line with alt+j / alt+k
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z
vnoremap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" new line in normal mode and back
nnoremap <leader>[ myO<ESC>`y
nnoremap <leader>] myo<ESC>`y

" open terminal
nnoremap <leader>' :sp term://bash<CR>i
tnoremap <Esc> <C-\><C-n><C-w>q
tnoremap jk <C-\><C-n>

" cycle through commands
cnoremap <c-n>  <down>
cnoremap <c-p>  <up>

" disable hl with 2 esc
noremap <silent><esc> <esc>:noh<CR><esc>

" trim white spaces
nnoremap <F2> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

"" FZF
nnoremap <silent> <leader>f :Files<CR>
nnoremap <leader>bb :Buffers<CR>
nnoremap <leader>: :Commands<CR>
nnoremap <leader>bt :BTags<CR>
nnoremap <leader>/ :Rg<CR>
nnoremap <leader>gc :Commits<CR>
nnoremap <leader>gs :GFiles?<CR>
nnoremap <leader>h :History<CR>
nmap <F1> <plug>(fzf-maps-n)
imap <F1> <plug>(fzf-maps-i)
vmap <F1> <plug>(fzf-maps-x)

"" coc
" Use tab to accept snippet expansion
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-y>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation
nmap <leader>cd <Plug>(coc-definition)
nmap <leader>ct <Plug>(coc-type-definition)
nmap <leader>ci <Plug>(coc-implementation)
nmap <leader>cr <Plug>(coc-references)
nmap <leader>cf <Plug>(coc-refactor)
nmap <leader>cc <Plug>(coc-fix-current)
" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
" Use CTRL-S for selections ranges.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
" other stuff
nmap <leader>lrn <Plug>(coc-rename)
nnoremap <leader>o :OR <CR>

" fugitive mappings
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gb :Gblame<CR>

" vim-go mappings
nmap <leader>lt :GoTest<CR>
nmap <leader>ll :GoMetaLint<CR>
nmap <leader>lc :GoCoverageToggle<CR>
nmap <leader>la :GoAlternate<CR>
nmap <leader>lr :GoRun<CR>
nmap <leader>li :GoImports<CR>
nmap <leader>lfs :GoFillStruct<CR>
nmap <leader>lie :GoIfErr<CR>
