" ================= Auto Install Plug ================== "
" if empty(glob('~/.config/nvim/autoload/plug.vim'))
"   silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
"     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall | source $MYVIMRC
" endif

" ================= Plugins ================== "
call plug#begin(expand('~/.config/nvim/plugged'))

" Color scheme and statusline
Plug 'astridlyre/falcon'
Plug 'hoob3rt/lualine.nvim'
Plug 'norcalli/nvim-colorizer.lua'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'

" Align, comments, git, tags
Plug 'junegunn/vim-easy-align'
Plug 'b3nj5m1n/kommentary'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'https://github.com/RRethy/nvim-treesitter-textsubjects'
Plug 'windwp/nvim-ts-autotag'
Plug 'andymass/vim-matchup'

" LSP and completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'windwp/nvim-autopairs'
Plug 'ray-x/lsp_signature.nvim'

" Snippets
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
call plug#end()
set termguicolors

" ==================== Lua Stuff ======================== "
lua require('config')

" ==================== general config ======================== "
set cmdheight=1                                     " Make hight 1 line
set foldmethod=manual                               " Manual folding only
set grepprg=rg\ --vimgrep                           " use rg as default grepper
set hidden                                          " Keep buffers around
set history=1000                                    " history limit
set ignorecase smartcase                            " highlight text while searching
set inccommand=nosplit                              " visual feedback while substituting
set list listchars=trail:»,tab:»-                   " use tab to navigate in list mode
set mouse=a                                         " Enable mouse scroll
set nobackup nowritebackup                          " Do not make backup files
set noshowmode                                      " Do not show mode under statusline
set number relativenumber                           " Line numbers and relative numbers
set shortmess+=actI                                 " Avoid more press enters
set showtabline=0                                   " Never show tabline
set signcolumn=yes                                  " Always show signcolumn
set cursorline                                      " Show line where cursor is
set spelllang=en_gb                                 " Canadian spelling
set splitright splitbelow                           " Splits
set tabstop=4 softtabstop=4 shiftwidth=4            " tab width
set termguicolors                                   " True colors
set tw=80                                           " auto wrap lines
set undofile undodir=/tmp                           " enable persistent undo
set updatetime=100                                  " For CursorHold autocmd
set wildignorecase
set wildignore=*.git/*,*.tags,tags,*.o,*.class,*.ccls-cache,*/node_modules/*
set wildmode=longest:full,full
set wrap breakindent                                " wrap long lines to the width set by tw

" ==================== performance tweaks ======================== "
set completeopt=menuone,noselect                    " Default complete opt
set lazyredraw                                      " Performance boost for macros
set maxmempattern=100000                            " Max mem to use
set pumheight=20                                    " Max 20 items at once
set redrawtime=10000                                " Allow more time for redraws
set synmaxcol=180                                   " No syntax on long lines
set timeoutlen=850                                  " Time to wait between keypress

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
colorscheme falcon

" For quickfix / location list toggle
let g:moonlight_qf_g = 0
let g:moonlight_qf_l = 0
let g:autoFormat = 1

" fzf
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }
let g:fzf_tags_command = 'ctags -R'
let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
let $FZF_DEFAULT_COMMAND = "rg --files --follow --hidden --glob '!.git/**' --glob '!build/**' --glob '!node_modules/**' --glob '!vendor/bundle/**'"

" ======================== Commands ============================= "
au BufEnter * set fo-=c fo-=r fo-=o " stop annoying auto commenting on new lines
au FileType help wincmd L           " open help in vertical split
au FileType qf set nobuflisted      " no quickfix in buffer list

" No line numbers or relative numbers in terminal window
augroup TerminalEnter
    autocmd!
    au TermOpen * setlocal nonumber
    au TermOpen * setlocal norelativenumber
augroup end

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
autocmd BufWritePre * if index(autoFormatable, &ft) >= 0 && g:autoFormat == 1
    \ | exe 'lua vim.lsp.buf.formatting_sync(nil, 1000)' | endif

" Strip whitespace
command! StripWhitespace :%s/\s\+$//e

" Advanced grep
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

" lorem ipsum
iab <expr> lorem system('curl -s http://metaphorpsum.com/paragraphs/1')

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
nnoremap <silent><leader>e :call ResetHightlight()<CR>
nnoremap <leader>; :w<CR>
nnoremap <leader>\ :qa!<CR>
nnoremap <silent><leader>q :call ToggleQFList(0)<CR>
nnoremap <leader>j :lnext<CR>zz
nnoremap <leader>k :lprev<CR>zz
nnoremap <silent><leader>af :call ToggleAutoFormat()<CR>

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

" vim-easy-align <leader>a
xmap <leader>a <Plug>(EasyAlign)
nmap <leader>a <Plug>(EasyAlign)

" =================== Normal Mappings ==========================
" Easier move line with alt+j / alt+k
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprev<CR>
nnoremap <silent> <C-q> :call ToggleQFList(1)<CR>
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
inoremap <C-c> <ESC>
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
