" ================= Auto Install Plug ================== "
" if empty(glob('~/.config/nvim/autoload/plug.vim'))
"   silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif

" ================= Plugins ================== "
call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'astridlyre/vim-moonlight'                             " Colorscheme
Plug 'mhinz/vim-startify'                                   " Fancy start screen
Plug 'neoclide/coc.nvim', {'branch': 'release'}             " LSP and more
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }         " fzf itself
Plug 'junegunn/fzf.vim'                                     " fuzzy search integration
Plug 'junegunn/vim-easy-align'                              " Easy align
Plug 'honza/vim-snippets'                                   " actual snippets
Plug 'tpope/vim-commentary'                                 " better commenting
Plug 'tpope/vim-fugitive'                                   " git support
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Syntax support
Plug 'jiangmiao/auto-pairs'                                 " Auto bracket pairs
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }          " Go lang plugin
call plug#end()

" ==================== Treesitter ======================== "
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
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

" ==================== statusline ======================== "
set statusline=                                                               " Clear default statusline
set statusline+=\ %#moonlightLime#❱\ %t                                       " Filename
set statusline+=%=                                                            " Spacer
set statusline+=\ %#moonlightGrey246#%m                                       " Modified symbol
set statusline+=\ %#moonlightPurple#%y                                        " Filetype
set statusline+=\ %#moonlightGrey246#%{&fileencoding?&fileencoding:&encoding} " Encoding
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
set tw=100                                          " auto wrap lines
set history=1000                                    " history limit
set undofile undodir=/tmp                           " enable persistent undo
set inccommand=nosplit                              " visual feedback while substituting
set grepprg=rg\ --vimgrep                           " use rg as default grepper
set wildmode=longest:full,full
set wildignorecase
set wildignore=*.git/*,*.tags,tags,*.o,*.class,*.ccls-cache
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
set scrolljump=5 scrolloff=5                        " Keep cursor 5 lines from edges
set lazyredraw                                      " Performance boost for macros
set redrawtime=10000                                " Allow more time for redraws
set synmaxcol=180                                   " No syntax on long lines
set timeoutlen=850                                  " Time to wait between keypress
set maxmempattern=20000                             " Max mem to use

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
let g:moonlightTransparent = 1
colorscheme moonlight

" Ensure coc-extensions are installed
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
            \'coc-pyright',
            \'coc-rust-analyzer',
            \'coc-diagnostic' ]

" FZF
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }
let g:fzf_tags_command = 'ctags -R'
let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' --glob '!build/**' --glob '!node_modules/**' --glob '!vendor/bundle/**'"

" vim-go
let g:go_fmt_autosave = 1
let g:go_fmt_command  = "goimports"

let g:startify_bookmarks = [ { 'c': '~/.config/nvim/init.vim' } ]
let g:startify_padding_left = 4
let g:startify_files_number = 5
let g:startify_custom_header = [
      \ '                                 _ _       _     _',
      \ '     _ __ ___   ___   ___  _ __ | (_) __ _| |__ | |_',
      \ "    | '_ ` _ \\ / _ \\ / _ \\| '_ \\| | |/ _` | '_ \\| __|",
      \ "    | | | | | | (_) | (_) | | | | | | (_| | | | | |_",
      \ '    |_| |_| |_|\___/ \___/|_| |_|_|_|\__, |_| |_|\__|',
      \ '                                     |___/'
      \]

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

" coc completion popup
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

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

" format with available file format formatter
command! -nargs=0 Format :call CocAction('format')

" organize imports
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

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

" Temporary fix for when treesitter highlight goes wonky
function! ResetHightlight()
  execute 'write | edit | TSBufEnable highlight'
endfunction

" Spell checking on
function! SpellOn()
  set spell
  echo "Spell Check Enabled"
endfunction

" Spell checking off
function! SpellOff()
  set nospell
  echo "Spell Check Disabled"
endfunction

" =================== Global Mappings ==========================
" Easy edit vim config
map <F3> :e ~/.config/nvim/init.vim<CR>
map <F2> :StripWhitespace<CR>

" Disable s and make y consistent
nmap s <Nop>
map Y y$

" =================== Leader Mappings ==========================
" Map leader to space
let mapleader=' '

" Install or Update Plugins
nnoremap <leader>lf :Format<CR>
nnoremap <leader>i :PlugInstall<CR>
nnoremap <leader>u :PlugUpdate<CR>
nnoremap <leader>\ :qa!<CR>
nnoremap <leader>r :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>e :call ResetHightlight()<CR>
nnoremap <leader>w :w<CR>

" Easy Buffer switching
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>

" new line in normal mode and back
nnoremap <leader>[ myO<ESC>`y
nnoremap <leader>] myo<ESC>`y

" open terminal
nnoremap <leader>' :sp term://bash<CR>i

" lil scripties
vnoremap <leader>s !sort -d -b -f<CR>
vnoremap <leader>bc !scriptbc<CR>

" easy system clipboard copy & paste
nnoremap <leader>Y mqgg"+yG`q
nnoremap <leader>cp "+p
nnoremap <leader>y "+y
vnoremap <leader>Y "+Y
vnoremap <leader>cp "+p
vnoremap <leader>y "+y

" FZF
nmap <leader>/ :Rg<CR>
nmap <leader>: :Commands<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>tt :BTags<CR>
nmap <leader>tc :Commits<CR>
nmap <leader>tf :GFiles?<CR>
nmap <leader>h :History<CR>
nmap <leader>f :Files<CR>

" coc-commands
nmap <leader>cu :CocUpdate<CR>
nmap <leader>cc <Plug>(coc-fix-current)
nmap <leader>cd <Plug>(coc-definition)
nmap <leader>cl <Plug>(coc-codelens-action)
nmap <leader>cf <Plug>(coc-refactor)
nmap <leader>ci <Plug>(coc-implementation)
nmap <leader>cn <Plug>(coc-rename)
nmap <leader>cr <Plug>(coc-references)
nmap <leader>ct <Plug>(coc-type-definition)
nmap <leader>c] <Plug>(coc-diagnostic-next)
nmap <leader>c[ <Plug>(coc-diagnostic-prev)
nmap <leader>o :OR <CR>

" fugitive mappings
nmap <leader>tb :Git blame<CR>
nmap <leader>td :Gdiffsplit<CR>

" vim-go mappings
nmap <leader>ga :GoAlternate<CR>
nmap <leader>gc :GoCoverageToggle<CR>
nmap <leader>ge :GoIfErr<CR>
nmap <leader>gi :GoImports<CR>
nmap <leader>gl :GoMetaLint<CR>
nmap <leader>gr :GoRun<CR>
nmap <leader>gs :GoFillStruct<CR>
nmap <leader>gt :GoTest<CR>

" vim-easy-align
xmap <leader>a <Plug>(EasyAlign)
nmap <leader>a <Plug>(EasyAlign)

" =================== Normal Mappings ==========================
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Easier move line with alt+j / alt+k
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z

" Disable hl with 2 esc
noremap <silent><esc><esc> :noh<CR><esc>

" Spelling
nmap so :call SpellOn()<CR>
nmap sf :call SpellOff()<CR>

" =================== Visual Mappings ==========================
" Easier move line with alt+j / alt+k
vnoremap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Coc function and class text objects and selection ranges
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" =================== Terminal Mappings ==========================
" Easier close terminal
tnoremap <Esc> <C-\><C-n><C-w>q

" =================== Insert Mappings ==========================
imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)
imap <C-j> <Plug>(coc-snippets-expand-jump)
inoremap <expr> <CR> pumvisible() ? "\<C-e>\<CR>" : "\<CR>"
inoremap jk <ESC>
