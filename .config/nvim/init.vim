scriptencoding=utf8

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
let g:moonlight_qf_g = 0
let g:moonlight_qf_l = 0
let g:autoFormat = 1
let g:falcon_bold = 1
let g:falcon_italic = 1
let g:nvim_tree_gitignore = 1
let g:nvim_tree_highlight_opened_files = 1
let g:nvim_tree_add_trailing = 1
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'notify',
    \     'packer',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }
let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 }
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': '✗',
    \   'staged': '✓',
    \   'unmerged': '',
    \   'renamed': '➜',
    \   'untracked': '★',
    \   'deleted': '',
    \   'ignored': '◌'
    \   },
    \ 'folder': {
    \   'arrow_open': '',
    \   'arrow_closed': '',
    \   'default': '',
    \   'open': '',
    \   'empty': '',
    \   'empty_open': '',
    \   'symlink': '',
    \   'symlink_open': '',
    \   },
    \   'lsp': {
    \     'hint': '',
    \     'info': '',
    \     'warning': '',
    \     'error': '',
    \   }
    \ }
set termguicolors " has to be set before nvim-colorizer is loaded

" ========================= lua config =================================== "
lua require('config')

" ========================= general config =============================== "
set breakindent                                               " wrap long lines to the width set by tw
set completeopt=menuone,noinsert                              " default complete opt
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
set pumheight=16                                              " max 15 items at once
set redrawtime=8000                                           " time to wait for redraws
set shortmess=aoOTIcF                                         " status messages
set showbreak=↳\ \                                            " show when lines wrap
set sidescroll=5 scrolloff=3                                  " scroll off
set signcolumn=yes                                            " always show signcolumn
set spelllang=en_gb                                           " canadian spelling
set splitright splitbelow                                     " splits
set synmaxcol=180                                             " no syntax on long lines
set tabstop=4 softtabstop=4 shiftwidth=4 shiftround           " tab width
set textwidth=80                                              " auto wrap lines
set timeoutlen=800                                            " time to wait between keypress
set ttimeoutlen=10                                            " timeout for key sequence
set undofile undodir=/tmp                                     " enable persistent undo
set updatetime=250                                            " for cursorhold autocmd
set wildignorecase                                            " ignore case in commands
set wildignore=.git,*.tags,tags,*.o,**/node_modules/**        " ignore paths
set wildmode=longest:full,full                                " mode for matching

" ========================= autocommands ================================= "
augroup AutoSelect
	autocmd!
	autocmd InsertEnter * set completeopt=menuone,noinsert
augroup end

" augroup AutoStartCoq
" 	autocmd!
" 	autocmd VimEnter * execute "COQnow"
" augroup end

augroup HelpSplit     " open help in vertical split
	autocmd!
	autocmd FileType help wincmd L
augroup end

augroup NoListQuick   " no quickfix in buffer list
	autocmd!
	autocmd FileType qf set nobuflisted
augroup end

augroup TerminalEnter " no line numbers or relative numbers in terminal window
    autocmd!
    autocmd TermOpen * setlocal nonumber
    autocmd TermOpen * setlocal norelativenumber
augroup end

augroup CursorLine    " show cursorline only in focused window
	autocmd!
	autocmd WinEnter,BufEnter,InsertLeave * if ! &cursorline && win_gettype() != 'popup' && ! &pvw | setlocal cursorline | endif
	autocmd WinLeave,BufLeave,InsertEnter * if &cursorline && win_gettype() != 'popup' && ! &pvw | setlocal nocursorline | endif
augroup end

augroup WinResize     " resize windows automatically
	autocmd!
	autocmd VimResized * tabdo wincmd =
augroup end

augroup SpellCheck    " enable spell only if file type is normal text
	autocmd!
	let spellable = ['markdown', 'gitcommit', 'txt', 'text', 'liquid', 'rst']
	autocmd BufEnter * if index(spellable, &ft) < 0 | set nospell | else | set spell | endif
augroup end

augroup HighlightYank " highlight yanked text
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}
augroup end

augroup ReturnPos    " return to last edit position when opening files
	autocmd!
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup end

augroup AutoFormat   " autoformat on save
	autocmd!
	let autoFormatable = ['markdown', 'sh', 'bash', 'python', 'javascript', 'rust',
		\ 'go', 'yaml', 'html', 'css', 'json', 'lua', 'c', 'typescript', 'javascriptreact', 'typescriptreact']
	autocmd BufWritePre * if index(autoFormatable, &ft) >= 0 && g:autoFormat == 1
		\ | exe 'lua vim.lsp.buf.formatting_sync(nil, 1000)' | endif
augroup end

iabbr ressm @media screen and (min-width: 601px) {
iabbr resmd @media screen and (min-width: 901px) {
iabbr reslg @media screen and (min-width: 1281px) {
iabbr resxl @media screen and (min-width: 1921px) {

" ========================= custom commands ============================== "
" strip whitespace
command! StripWhitespace :%s/\s\+$//e

" ========================= custom functions ============================= "
function! ResetHightlight() " temporary fix for when treesitter highlight goes wonky
    execute 'write | edit | TSBufEnable highlight'
endfunction

function! ToggleAutoFormat() " turn on / off formatting on save
    if g:autoFormat == 1 | let g:autoFormat = 0 | echo 'Autoformatting disabled'
    else | let g:autoFormat = 1 | echo 'Autoformatting enabled' | end
endfunction

function! ToggleQFList(global) " toggle quickfix
    if a:global == 1
        if g:moonlight_qf_g == 1 | let g:moonlight_qf_g = 0 | cclose | else
            let g:moonlight_qf_g = 1 | copen | end
    else
        if g:moonlight_qf_l == 1 | let g:moonlight_qf_l = 0 | lclose | else
            let g:moonlight_qf_l = 1 | lopen | end
    end
endfunction

" ========================= global mappings ============================== "
" disable s and make y consistent
" nmap s <nop>
map Y y$

" ========================= leader mappings ============================== "
" map leader to space
let mapleader=' '

" edit configs
nnoremap <leader>ee :e ~/projects/dotfiles/.config/nvim/init.vim<cr>

" misc helper things <leader>?
nnoremap <leader>u :PackerUpdate<cr>
nnoremap <leader>j :lnext<cr>zz
nnoremap <leader>k :lprev<cr>zz
nnoremap <leader>\ :qa!<cr>
nnoremap <leader>si :so ~/.config/nvim/init.vim<cr>
nnoremap <leader>; :w<cr>
nnoremap <silent><leader>af <cmd>call ToggleAutoFormat()<cr>
nnoremap <silent><leader><esc> <cmd>call ResetHightlight()<cr>
nnoremap <silent><leader>q <cmd>call ToggleQFList(0)<cr>
nnoremap <silent><leader>p <C-^>
nnoremap ' `
nnoremap ` '

" new line in normal mode and back
nnoremap <leader>[ myO<esc>`y
nnoremap <leader>] myo<esc>`y

" open terminal
nnoremap <leader>' :10sp term://bash<cr>i
tnoremap <C-d> <C-\><C-n>

" lil scripties <leader>s*
vnoremap <leader>ss !sort -d -b -f<cr>
vnoremap <leader>sc !scriptbc<cr>
nnoremap <leader>sw <cmd>StripWhitespace<cr>

" easy system clipboard copy & paste
nnoremap <leader>y "+y
vnoremap <leader>y "+y

nnoremap <C-n> <cmd>NvimTreeToggle<CR>
nnoremap <leader><cr> <cmd>NvimTreeRefresh<CR>

nnoremap <leader><space> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>lg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>b <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references<cr>
nnoremap <leader>fa <cmd>lua require('telescope.builtin').lsp_code_actions<cr>
nnoremap <leader>fd <cmd>lua require('telescope.builtin').lsp_definitions<cr>
nnoremap <leader>fi <cmd>lua require('telescope.builtin').lsp_implementations<cr>
nnoremap <leader>f; <cmd>lua require('telescope.builtin').lsp_range_code_actions<cr>
nnoremap <leader>d <cmd>lua MiniBufremove.delete()<cr>

" fugitive mappings <leader>g[bd]
nmap <leader>gb <cmd>Git blame<cr>
nmap <leader>gs <cmd>Git<cr>
nmap <leader>gd <cmd>Gdiffsplit<cr>

" vim-easy-align <leader>a
xmap <leader>a <Plug>(EasyAlign)
nmap <leader>a <Plug>(EasyAlign)

" ========================= normal mappings ============================== "
" Add big j/k jumps to jumplist
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" easier move line with alt+j / alt+k
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z
nnoremap <Tab> <cmd>bnext<cr>
nnoremap <S-Tab> <cmd>bprev<cr>
nnoremap <silent> <C-q> <cmd>call ToggleQFList(1)<cr>
nnoremap <C-j> <cmd>cnext<cr>zz
nnoremap <C-k> <cmd>cprev<cr>zz

" disable hl with 2 esc
noremap <silent><esc><esc> <cmd>noh<cr><esc>

" ========================= insert mappings ============================== "
inoremap <C-c> <esc>
inoremap <C-d> <del>
inoremap <C-b> <left>
inoremap <C-f> <right>
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap <silent><expr> <C-y> pumvisible() ? (complete_info().selected == -1 ? "\<C-n><C-y>" : "\<C-y>") : "\<C-y>"
inoremap <silent><expr> <C-w> pumvisible() ? "\<C-e><C-w>" : "\<C-w>"

" ========================= command mode mappings ======================== "
cnoremap <C-b> <left>
cnoremap <C-f> <right>
cnoremap <C-a> <home>
cnoremap <C-e> <end>
cnoremap <C-d> <del>
