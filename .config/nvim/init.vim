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
let g:omni_sql_no_default_maps = 1
let g:loaded_python_provider   = 0
let g:loaded_perl_provider     = 0
let g:loaded_ruby_provider     = 0
let g:python3_host_prog        = '/usr/bin/python3'
let g:moonlight_qf_g = 0
let g:moonlight_qf_l = 0
let g:autoFormat = 1
let g:substrata_variant = "brighter"
let g:substrata_italic_booleans = "true"
let g:matchup_matchparen_offscreen = {'method': 'popup'}
let g:conjure#eval#result_register = '*'
let g:conjure#log#botright = v:true
let g:conjure#mapping#doc_word  = 'gk'

" ========================= general config =============================== "
set termguicolors " has to be set before nvim-colorizer is loaded
set breakindent                                               " wrap long lines to the width set by tw
set completeopt=menuone,noinsert                              " default complete opt
set formatoptions=1jql                                        " text formatting options
set grepformat=%f:%l:%c:%m                                    " grep format
set grepprg=rg\ --hidden\ --vimgrep\ --smart-case\ --         " use rg for vimgrep
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
set synmaxcol=120                                             " no syntax on long lines
set tabstop=4 softtabstop=4 shiftwidth=4 shiftround           " tab width
set textwidth=80                                              " auto wrap lines
set timeoutlen=800                                            " time to wait between keypress
set ttimeoutlen=10                                            " timeout for key sequence
set undofile undodir=/tmp                                     " enable persistent undo
set updatetime=250                                            " for cursorhold autocmd
set wildignorecase                                            " ignore case in commands
set wildignore=.git,*.tags,tags,*.o,**/node_modules/**        " ignore paths
set wildmode=longest:full,full                                " mode for matching
set jumpoptions=stack                                         " jump stack like browser history

" ========================= autocommands ================================= "
augroup AutoSelect
	autocmd!
	autocmd InsertEnter * set completeopt=menuone,noinsert
augroup end

augroup HelpSplit     " open help in vertical split
	autocmd!
	autocmd FileType help wincmd L
augroup end

augroup NoListQuick   " no quickfix in buffer list
	autocmd!
	autocmd FileType qf set nobuflisted
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

augroup SpellCheck    " enable spell only if file type is normal txt
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
		\ 'go', 'yaml', 'html', 'css', 'json', 'lua', 'c', 'typescript', 'javascriptreact', 'typescriptreact', "clojure", "fennel"]
	autocmd BufWritePre * if index(autoFormatable, &ft) >= 0 && g:autoFormat == 1
		\ | exe 'lua vim.lsp.buf.formatting_sync(nil, 1000)' | endif
augroup end

augroup Racket
	autocmd!
	autocmd BufReadPost *.rkt,*.rktl set filestype=scheme
augroup end

augroup Javascript
	autocmd!
	autocmd BufEnter *.js,*.ts,*.jsx,*.tsx nnoremap <leader>r <cmd>1TermExec cmd="p run dev"<CR>
	autocmd BufEnter *.js,*.ts,*.jsx,*.tsx nnoremap <leader>t <cmd>2TermExec cmd="p run test"<CR>
augroup end

augroup Rust
	autocmd!
	autocmd BufEnter *.rs nnoremap <leader>r <cmd>1TermExec cmd="cargo run"<CR>
	autocmd BufEnter *.rs nnoremap <leader>t <cmd>2TermExec cmd="cargo test"<CR>
augroup end

augroup Clojure
	autocmd!
	autocmd BufEnter *.clj nnoremap <leader>r <cmd>1TermExec cmd='clj -m nrepl.cmdline --middleware "[cider.nrepl/cider-middleware]" --interactive'<CR>
augroup end

augroup ClojureScript
	autocmd!
	autocmd! BufEnter .cljs nnoremap <leader>r <cmd>1TermExec cmd="pnpx shadow-cljs watch todo"
	autocmd! BufEnter .cljs nnoremap <leader>t <cmd>2TermExec cmd="pnpx shadow-cljs test todo"
augroup end

augroup PackerUpdate
	autocmd!
	autocmd BufWritePost init.lua exec 'PackerCompile'
augroup end

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
nnoremap ^ 0
nnoremap 0 ^
nmap j gj
nmap k gk

" ========================= leader mappings ============================== "
" map leader to space
let mapleader=' '
let maplocalleader=','

" misc helper things <leader>?
nnoremap <leader>u :PackerUpdate<cr>
nnoremap <leader>; :w<cr>
nnoremap <silent><leader>af <cmd>call ToggleAutoFormat()<cr>
nnoremap <silent><leader><esc> <cmd>call ResetHightlight()<cr>
nnoremap ' `
nnoremap ` '

" new line in normal mode and back
nnoremap <leader>[ myO<esc>`y
nnoremap <leader>] myo<esc>`y
tnoremap <C-q> <C-\><C-n>

" ToggleTerm
nnoremap <leader>\ <cmd>ToggleTermToggleAll<CR>
nnoremap <leader>1 <cmd>ToggleTerm1<CR>
nnoremap <leader>2 <cmd>ToggleTerm2<CR>
nnoremap <leader>3 <cmd>ToggleTerm3<CR>
nnoremap <leader>4 <cmd>ToggleTerm4<CR>

" lil scripties <leader>s*
vnoremap <leader>ss !sort -d -b -f<cr>

" easy system clipboard copy & paste
nnoremap <leader>y "+y
vnoremap <leader>y "+y
vnoremap <c-c> <esc>

" NvimTree
nnoremap <c-n> <cmd>NvimTreeToggle<CR>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files hidden=true follow=true<cr>
nnoremap <leader>f- <cmd>Telescope file_browser<cr>
nnoremap <leader>lg <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope find_buffers<cr>
nnoremap <leader>fh <cmd>Telescope oldfiles<cr>
nnoremap <leader>fq <cmd>Telescope quickfix<cr>
nnoremap <leader>fr <cmd>Telescope lsp_references<cr>
nnoremap <leader>fa <cmd>Telescope lsp_code_actions<cr>
nnoremap <leader>fd <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>fi <cmd>Telescope lsp_implementations<cr>
nnoremap <leader>f; <cmd>Telescope lsp_range_code_actions<cr>
nnoremap <leader>d <cmd>lua MiniBufremove.delete()<cr>
nnoremap gql <cmd>lua vim.diagnostic.setqflist()<CR>

" fugitive mappings <leader>g[bd]
nmap <leader>gb <cmd>Git blame<cr>
nmap <leader>gs <cmd>Git<cr>
nmap <leader>gd <cmd>Gdiffsplit<cr>

" Conjure
nnoremap <localleader>cc <cmd>ConjureConnect<CR>

" ========================= normal mappings ============================== "
" Add big j/k jumps to jumplist
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" easier move line with alt+j / alt+k
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z
nnoremap <silent> <C-q> <cmd>call ToggleQFList(1)<cr>

" disable hl with 2 esc
noremap <silent><c-c><c-c> <cmd>noh<cr><esc>

nnoremap [b <cmd>bprev<cr>
nnoremap ]b <cmd>bnext<cr>
nnoremap [q <cmd>cnext<cr>
nnoremap ]q <cmd>cprev<cr>
nnoremap [<space> myO<esc>`y
nnoremap ]<space> myo<esc>`y

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

" ========================= lua config =================================== "
lua require("impatient")
lua require('moonlight')
