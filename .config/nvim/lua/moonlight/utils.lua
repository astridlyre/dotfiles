local M = {}

function M.map(mode, from, to, opts)
	return vim.keymap.set(mode, from, to, opts)
end

function M.nmap(from, to, opts)
	return M.map("n", from, to, opts)
end

function M.lmap(from, to, opts)
	return M.map("n", "<leader>" .. from, to, opts)
end

function M.imap(from, to, opts)
	return M.map("i", from, to, opts)
end

function M.vmap(from, to, opts)
	return M.map("v", from, to, opts)
end

function M.cmap(from, to, opts)
	return M.map("c", from, to, opts)
end

function M.tmap(from, to, opts)
	return M.map("t", from, to, opts)
end

return M
