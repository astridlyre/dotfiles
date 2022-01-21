local M = {}

function M.setup()
	-- Autocommands
	vim.cmd([[
augroup HelpSplit     " open help in vertical split
	autocmd!
	autocmd FileType help wincmd L
augroup end
]])

	vim.cmd([[
augroup NoListQuick   " no quickfix in buffer list
	autocmd!
	autocmd FileType qf set nobuflisted
augroup end
]])

	vim.cmd([[
augroup CursorLine    " show cursorline only in focused window
	autocmd!
	autocmd WinEnter,BufEnter,InsertLeave * if ! &cursorline && win_gettype() != 'popup' && ! &pvw | setlocal cursorline | endif
	autocmd WinLeave,BufLeave,InsertEnter * if &cursorline && win_gettype() != 'popup' && ! &pvw | setlocal nocursorline | endif
augroup end
]])

	vim.cmd([[
augroup WinResize     " resize windows automatically
	autocmd!
	autocmd VimResized * tabdo wincmd =
augroup end
]])

	vim.cmd([[
augroup SpellCheck    " enable spell only if file type is normal txt
	autocmd!
	let spellable = ['markdown', 'gitcommit', 'txt', 'text', 'liquid', 'rst']
	autocmd BufEnter * if index(spellable, &ft) < 0 | set nospell | else | set spell | endif
augroup end
]])

	vim.cmd([[
augroup HighlightYank " highlight yanked text
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}
augroup end
]])

	vim.cmd([[
augroup ReturnPos    " return to last edit position when opening files
	autocmd!
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup end
]])

	vim.cmd([[
augroup PackerUpdate
	autocmd!
	autocmd BufWritePost init.lua exec 'PackerCompile'
augroup end
]])
end

return M
