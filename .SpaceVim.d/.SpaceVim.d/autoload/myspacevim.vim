function! myspacevim#before() abort
	let g:loaded_python_provider = 0
	let g:loaded_perl_provider = 0
	let g:loaded_ruby_provider = 0
	let g:python3_host_prog = "/usr/bin/python3.8"
	let g:node_host_prog = "/home/astrid/.fnm/node-versions/v15.5.0/installation/bin/neovim-node-host"
	let g:mapleader = ','

	" Essentials
	nnoremap ; :
	nmap <leader>w :w<cr>
	nmap <Tab> :bnext<CR>
	nmap <S-Tab> :bprevious<CR>
	map Y y$
	cnoremap jk <ESC> 

	" Remap move keys
	nmap <M-j> mz:m+<cr>`z
	nmap <M-k> mz:m-2<cr>`z
	vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
	vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
endfunction

function! myspacevim#after() abort
	execute "TSEnable highlight"
  execute "TSEnableAll highlight"
	augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
	augroup END
endfunction
