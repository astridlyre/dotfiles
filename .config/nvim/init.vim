" ================= Auto Install Plug ================== "
" if empty(glob('~/.config/nvim/autoload/plug.vim'))
"   silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif

" ================= Plugins ================== "
call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'bluz71/vim-moonfly-colors'                            " Colorscheme
Plug 'neoclide/coc.nvim', {'branch': 'release'}             " LSP and more
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }         " fzf itself
Plug 'junegunn/fzf.vim'                                     " fuzzy search integration
Plug 'junegunn/vim-easy-align'                              " Easy align
Plug 'SirVer/ultisnips'                                     " snippets manager
Plug 'honza/vim-snippets'                                   " actual snippets
Plug 'Yggdroot/indentLine'                                  " show indentation lines
Plug 'tpope/vim-commentary'                                 " better commenting
Plug 'tpope/vim-fugitive'                                   " git support
Plug 'machakann/vim-sandwich'                               " make sandwiches
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
set statusline=                                            " Clear default statusline
set statusline+=\ %#MoonflyEmerald#%t                      " Filename
set statusline+=%=                                         " Spacer
set statusline+=\ %#MoonflyGrey246#%m                      " Modified symbol
set statusline+=\ %#MoonflyGrey241#%y                      " Filetype
set statusline+=\ %{&fileencoding?&fileencoding:&encoding} " Encoding
set statusline+=\ %p%%\                                    " Percent

" ==================== general config ======================== "
set number                                          " Line numbers
set relativenumber                                  " Relative line numbers
set termguicolors                                   " True colors
set mouse=a                                         " Enable mouse scroll
set foldmethod=manual                               " Manual folding only
set tabstop=2 softtabstop=2 shiftwidth=2 autoindent " tab width
set expandtab                                       " Expand tab into spaces
set ignorecase smartcase                            " highlight text while searching
set list listchars=trail:»,tab:»-                   " use tab to navigate in list mode
set wrap breakindent                                " wrap long lines to the width set by tw
set showtabline=0                                   " Never show tabline
set noshowmode                                      " Do not show mode under statusline
set conceallevel=2                                  " Necessary for Indentline
set splitright                                      " open vertical split to the right
set splitbelow                                      " open horizontal split to the bottom
set tw=90                                           " auto wrap lines
set emoji                                           " enable emojis
set history=1000                                    " history limit
set undofile                                        " enable persistent undo
set undodir=/tmp                                    " undo temp file directory
set inccommand=nosplit                              " visual feedback while substituting
set grepprg=rg\ --vimgrep                           " use rg as default grepper
set nocursorline                                    " Do not show cursorline
set nocursorcolumn                                  " Do not show cursorcolumn
set scrolljump=5                                    " Keep cursor 10 lines from edges
set scrolloff=5                                     " Keep cursor 10 lines from edges
set lazyredraw                                      " Performance boost for macros
set redrawtime=10000                                " Allow more time for redraws
set synmaxcol=180                                   " No syntax on long lines
set timeoutlen=850                                  " Time to wait between keypress
set maxmempattern=20000                             " Max mem to use
set wildmode=longest:full,full
set wildignorecase
set wildignore=*.git/*,*.tags,tags,*.o,*.class,*.ccls-cache
set re=1
set hidden                                          " Keep buffers around
set nobackup                                        " Do not make backup files
set nowritebackup                                   " No write backups
set cmdheight=1                                     " Make hight 1 line
set updatetime=100                                  " For CursorHold autocmd
set shortmess+=actI                                 " Avoid more press enters
set signcolumn=yes                                  " Always show signcolumn
set spelllang=en_gb                                 " Canadian spelling

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
let g:moonflyTransparent = 1
colorscheme moonfly

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
            \'coc-diagnostic' ]

" indentLine
let g:indentLine_char_list  = ['▏', '¦', '┆', '┊']
let g:indentLine_setColors  = 0
let g:indentLine_setConceal = 0 " Fix conceal for markdown

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

" Disable s for vim-sandwich
nmap s <Nop>

" Make Y consistent
map Y y$

" =================== Leader Mappings ==========================
" Map leader to space
let mapleader=' '

" Write buffer as sudo
nnoremap <leader>sudo :w !sudo tee > /dev/null %

" Install or Update Plugins
nnoremap <leader>lf :Format<CR>
nnoremap <leader>pc :PlugClean<CR>
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

" open terminal
nnoremap <leader>' :sp term://bash<CR>i

" Simple sort
vnoremap <leader>s !sort<CR>

" Simple calc with bc
vnoremap <leader>c !scriptbc<CR>

" Spelling
nnoremap <leader>so :call SpellOn()<CR>
nnoremap <leader>sf :call SpellOff()<CR>

" easy system clipboard copy & paste
nnoremap <leader>Y mqgg"+yG`q
nnoremap <leader>p "+p
nnoremap <leader>y "+y
vnoremap <leader>Y "+Y
vnoremap <leader>p "+p
vnoremap <leader>y "+y

" FZF
nnoremap <leader>/ :Rg<CR>
nnoremap <leader>: :Commands<CR>
nnoremap <leader>bb :Buffers<CR>
nnoremap <leader>bt :BTags<CR>
nnoremap <leader>gc :Commits<CR>
nnoremap <leader>gs :GFiles?<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>f :Files<CR>

" coc-commands
nnoremap <leader>cu :CocUpdate<CR>
nnoremap <leader>cc <Plug>(coc-fix-current)
nnoremap <leader>cd <Plug>(coc-definition)
nnoremap <leader>cl <Plug>(coc-codelens-action)
nnoremap <leader>cf <Plug>(coc-refactor)
nnoremap <leader>ci <Plug>(coc-implementation)
nnoremap <leader>cn <Plug>(coc-rename)
nnoremap <leader>cr <Plug>(coc-references)
nnoremap <leader>ct <Plug>(coc-type-definition)
nnoremap <leader>d <Plug>(coc-diagnostic-next)
nnoremap <leader>D <Plug>(coc-diagnostic-prev)
nnoremap <leader>o :OR <CR>

" fugitive mappings
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gdiffsplit<CR>

" vim-go mappings
nnoremap <leader>ga :GoAlternate<CR>
nnoremap <leader>gc :GoCoverageToggle<CR>
nnoremap <leader>ge :GoIfErr<CR>
nnoremap <leader>gi :GoImports<CR>
nnoremap <leader>gl :GoMetaLint<CR>
nnoremap <leader>gr :GoRun<CR>
nnoremap <leader>gs :GoFillStruct<CR>
nnoremap <leader>gt :GoTest<CR>

" vim-easy-align
xmap <leader>a <Plug>(EasyAlign)
nmap <leader>a <Plug>(EasyAlign)

" =================== Normal Mappings ==========================
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Easy Buffer switching
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Easier move line with alt+j / alt+k
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z

" Disable hl with 2 esc
noremap <silent><esc><esc> :noh<CR><esc>

" Map jk to ESC in insert
inoremap jk <ESC>

" =================== Visual Mappings ==========================
" Easier move line with alt+j / alt+k
vnoremap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Coc function and class text objects
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

" =================== Terminal Mappings ==========================
" Easier close terminal
tnoremap <Esc> <C-\><C-n><C-w>q
tnoremap jk <C-\><C-n>
