local ok = pcall(require, "mini.pairs")
if ok and MiniPairs.unmap_buf then
	MiniPairs.unmap_buf(0, "i", "'", "'")
else
	pcall(vim.keymap.del, "i", "'", { buffer = 0 })
end
