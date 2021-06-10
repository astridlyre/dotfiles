" ========================= auto install plug ============================ "
" if empty(glob('~/.config/nvim/autoload/plug.vim'))
"   silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif

" ========================= plugins ====================================== "
call plug#begin(expand('~/.config/nvim/plugged'))

" color scheme and statusline
Plug 'astridlyre/falcon'
Plug 'hoob3rt/lualine.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'kyazdani42/nvim-web-devicons'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" align, comments, git, tags
Plug 'junegunn/vim-easy-align'
Plug 'b3nj5m1n/kommentary'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'https://github.com/RRethy/nvim-treesitter-textsubjects'
Plug 'windwp/nvim-ts-autotag'
Plug 'andymass/vim-matchup'

" lsp and completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'windwp/nvim-autopairs'
Plug 'ray-x/lsp_signature.nvim'

" snippets
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
call plug#end()
set termguicolors " has to be set before nvim-colorizer is loaded

" ========================= lua config =================================== "
lua require('config')

" ========================= general config =============================== "
set breakindent                                               " wrap long lines to the width set by tw
set completeopt=menuone,noselect                              " default complete opt
set formatoptions=1jql                                        " text formatting options
set grepformat=%f:%l:%c:%m                                    " grep format
set grepprg=rg\ --hidden\ --vimgrep\ --smart-case\ --         " use rg for vimgrep
set hidden                                                    " keep buffers around
set history=1000                                              " history limit
set ignorecase smartcase                                      " highlight text while searching
set inccommand=nosplit                                        " visual feedback while substituting
set lazyredraw                                                " performance boost for macros
set list listchars=tab:»·,nbsp:+,trail:·,extends:→,precedes:← " show hidden characters
set maxmempattern=100000                                      " max mem to use
set mouse=a                                                   " enable mouse scroll
set nobackup nowritebackup                                    " do not make backup files
set noshowmode                                                " do not show mode under statusline
set number relativenumber                                     " line numbers and relative numbers
set pumheight=15                                              " max 15 items at once
set redrawtime=8000                                           " time to wait for redraws
set shortmess=aoOTIcF                                         " status messages
set showbreak=↳\ \                                            " show when lines wrap
set showtabline=0                                             " never show tabline
set sidescroll=5                                              " scroll off sideways
set signcolumn=yes                                            " always show signcolumn
set spelllang=en_gb                                           " canadian spelling
set splitright splitbelow                                     " splits
set synmaxcol=180                                             " no syntax on long lines
set tabstop=4 softtabstop=4 shiftwidth=4 shiftround           " tab width
set textwidth=80                                              " auto wrap lines
set timeoutlen=800                                            " time to wait between keypress
set ttimeoutlen=10                                            " timeout for key sequence
set undofile undodir=/tmp                                     " enable persistent undo
set updatetime=100                                            " for cursorhold autocmd
set wildignorecase                                            " ignore case in commands
set wildignore=.git,*.tags,tags,*.o,**/node_modules/**        " ignore paths
set wildmode=longest:full,full                                " mode for matching

" ========================= plugin configuration ========================= "
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_matchit           = 1
let g:loaded_matchparen        = 1
let g:loaded_2html_plugin      = 1
let g:loaded_logiPat           = 1
let g:loaded_rrhelper          = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1
let g:omni_sql_no_default_maps = 1                  " disable sql omni completion
let g:loaded_python_provider   = 0                  " disable python2
let g:loaded_perl_provider     = 0                  " disable perl
let g:loaded_ruby_provider     = 0                  " disable ruby
let g:python3_host_prog        = '/usr/bin/python3' " default python3

" colorscheme
colorscheme falcon

" for quickfix / location list toggle
let g:moonlight_qf_g = 0
let g:moonlight_qf_l = 0
let g:autoFormat = 1

" ========================= autocommands ================================= "
au FileType help wincmd L           " open help in vertical split
au FileType qf set nobuflisted      " no quickfix in buffer list

" no line numbers or relative numbers in terminal window
augroup TerminalEnter
    autocmd!
    au TermOpen * setlocal nonumber
    au TermOpen * setlocal norelativenumber
augroup end

" show cursorline only in focused window
augroup CursorLine
	autocmd!
	au WinEnter,BufEnter,InsertLeave * if ! &cursorline && win_gettype() != 'popup' && ! &pvw | setlocal cursorline | endif
	au WinLeave,BufLeave,InsertEnter * if &cursorline && win_gettype() != 'popup' && ! &pvw | setlocal nocursorline | endif
augroup end

" resize windows automatically
autocmd VimResized * tabdo wincmd =

" enable spell only if file type is normal text
let spellable = ['markdown', 'gitcommit', 'txt', 'text', 'liquid', 'rst']
autocmd BufEnter * if index(spellable, &ft) < 0 | set nospell | else | set spell | endif

" set make program for go
autocmd BufEnter * if &ft == 'go' | set makeprg=go\ build\ % | endif

" highlight yanked text
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}
augroup END

" telescope if passed argument is a folder
augroup folderarg
	autocmd!
    autocmd VimEnter * if argc() != 0 && isdirectory(argv()[0]) | execute 'cd' fnameescape(argv()[0])  | endif
    autocmd VimEnter * if argc() != 0 && isdirectory(argv()[0]) 
				\| execute 'lua require("telescope.builtin").find_files({hidden=true, follow=true})' | endif
augroup END

" return to last edit position when opening files
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" autoformat on save
let autoFormatable = ['markdown', 'sh', 'bash', 'python', 'javascript', 'rust',
    \ 'go', 'yaml', 'html', 'css', 'json', 'lua', 'c', 'typescript']
autocmd BufWritePre * if index(autoFormatable, &ft) >= 0 && g:autoFormat == 1
    \ | exe 'lua vim.lsp.buf.formatting_sync(nil, 1000)' | endif

" strip whitespace
command! StripWhitespace :%s/\s\+$//e

" ========================= custom functions ============================= "
" temporary fix for when treesitter highlight goes wonky
function! ResetHightlight()
    execute 'write | edit | TSBufEnable highlight'
endfunction

" turn on / off formatting on save
fun! ToggleAutoFormat()
    if g:autoFormat == 1 | let g:autoFormat = 0 | echo "Autoformatting disabled"
    else | let g:autoFormat = 1 | echo "Autoformatting enabled" | end
endfun

" toggle quickfix
fun! ToggleQFList(global)
    if a:global == 1
        if g:moonlight_qf_g == 1 | let g:moonlight_qf_g = 0 | cclose | else
            let g:moonlight_qf_g = 1 | copen | end
    else
        if g:moonlight_qf_l == 1 | let g:moonlight_qf_l = 0 | lclose | else
            let g:moonlight_qf_l = 1 | lopen | end
    end
endfun

" ========================= global mappings ============================== "
" disable s and make y consistent
nmap s <nop>
map Y y$

" ========================= leader mappings ============================== "
" map leader to space
let mapleader=' '

" edit configs
nnoremap <leader>ee :e ~/projects/dotfiles/.config/nvim/init.vim<cr>

" install or update plugins <leader>p*
nnoremap <leader>ui :PlugInstall<cr>
nnoremap <leader>uu :PlugUpdate<cr>

" misc helper things <leader>?
nnoremap <leader>si :so ~/.config/nvim/init.vim<cr>
nnoremap <silent><leader><esc> <cmd>call ResetHightlight()<cr>
nnoremap <leader>; :w<cr>
nnoremap <leader>\ :qa!<cr>
nnoremap <silent><leader>q <cmd>call ToggleQFList(0)<cr>
nnoremap <leader>j :lnext<cr>zz
nnoremap <leader>k :lprev<cr>zz
nnoremap <silent><leader>af <cmd>call ToggleAutoFormat()<cr>
nnoremap <silent><leader>wg <cmd>!write-good %<cr>
nnoremap <silent><leader>r <cmd>lua require'ml-quickrun'.run_command()<cr>

" new line in normal mode and back
nnoremap <leader>[ myO<esc>`y
nnoremap <leader>] myo<esc>`y

" open terminal
nnoremap <leader>' :sp term://bash<cr>i

" lil scripties <leader>s*
vnoremap <leader>ss !sort -d -b -f<cr>
vnoremap <leader>sc !scriptbc<cr>
nnoremap <leader>sw <cmd>StripWhitespace<cr>

" easy system clipboard copy & paste
nnoremap <leader>Y mqgg"+yG`q
nnoremap <leader>cp "+p
nnoremap <leader>y "+y
vnoremap <leader>Y "+Y
vnoremap <leader>cp "+p
vnoremap <leader>y "+y

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files({hidden = true, follow = true})<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fc <cmd>Telescope git_commits<cr>
nnoremap <leader>fm <cmd>Telescope man_pages<cr>

" fugitive mappings <leader>g[bd]
nmap <leader>gb <cmd>Git blame<cr>
nmap <leader>gd <cmd>Gdiffsplit<cr>

" vim-easy-align <leader>a
xmap <leader>a <Plug>(EasyAlign)
nmap <leader>a <Plug>(EasyAlign)

" ========================= normal mappings ============================== "
" easier move line with alt+j / alt+k
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z
nnoremap <C-n> <cmd>bnext<cr>
nnoremap <C-p> <cmd>bprev<cr>
nnoremap <silent> <C-q> <cmd>call ToggleQFList(1)<cr>
nnoremap <C-j> <cmd>cnext<cr>zz
nnoremap <C-k> <cmd>cprev<cr>zz

" disable hl with 2 esc
noremap <silent><esc><esc> <cmd>noh<cr><esc>

" ========================= visual mappings ============================== "
" easier move line with alt+j / alt+k
vnoremap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vnoremap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" ========================= insert mappings ============================== "
inoremap <silent><expr> <C-e> compe#close('<C-e>')
inoremap <silent><expr> <C-y> compe#confirm('<C-y>')
inoremap <C-c> <esc>
inoremap <C-d> <del>
inoremap <C-b> <left>
inoremap <C-f> <right>
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" ========================= command mode mappings ======================== "
cnoremap <C-b> <left>
cnoremap <C-f> <right>
cnoremap <C-a> <home>
cnoremap <C-e> <end>
cnoremap <C-d> <del>
