local M = {}

function M.setup()
	vim.cmd([[
iabbr improt import
iabbr funciton function
iabbr exprot export
iabbr expotr export
	]])
	vim.cmd([[
augroup KittyConfig
	autocmd!
	autocmd BufEnter kitty.conf set filetype=kitty
augroup end
	]])
	vim.cmd([[
augroup GoLang
	autocmd!
	autocmd FileType go iabbr ;; :=
augroup end
	]])
	-- lambda abbreviation for racket
	vim.cmd([[
augroup Racket
	autocmd!
	autocmd FileType racket iabbr ld λ
augroup end
	]])

	-- don't list quickfix in buffers
	vim.cmd([[
augroup NoListQuick
	autocmd!
	autocmd FileType qf set nobuflisted
augroup end
]])

	-- show cursorline only in active buffer
	vim.cmd([[
augroup CursorLine
	autocmd!
	autocmd WinEnter,BufEnter,InsertLeave * if ! &cursorline && win_gettype() != 'popup' && ! &pvw | setlocal cursorline | endif
	autocmd WinLeave,BufLeave,InsertEnter * if &cursorline && win_gettype() != 'popup' && ! &pvw | setlocal nocursorline | endif
augroup end
]])

	-- resize windows automatically
	vim.cmd([[
augroup WinResize
	autocmd!
	autocmd VimResized * tabdo wincmd =
augroup end
]])

	-- enable spell if file type is text-related
	vim.cmd([[
augroup SpellCheck
	autocmd!
	let spellable = ['markdown', 'gitcommit', 'txt', 'text', 'liquid', 'rst']
	autocmd BufEnter * if index(spellable, &ft) < 0 | set nospell | else | set spell | endif
augroup end
]])

	-- highlight yanked text
	vim.cmd([[
augroup HighlightYank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}
augroup end
]])

	-- return to last position when opening files
	vim.cmd([[
augroup ReturnPos
	autocmd!
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup end
]])
end

return M
