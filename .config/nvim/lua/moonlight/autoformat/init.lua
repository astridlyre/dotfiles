local M = {}

M.autoformat_enabled = true

function M.format(bufnr)
	if M.autoformat_enabled then
		return require("moonlight.lsp").lsp_format(bufnr)
	else
		return
	end
end

function M.toggle_formatting()
	M.autoformat_enabled = not M.autoformat_enabled
	local status
	if M.autoformat_enabled then
		status = "enabled"
	else
		status = "disabled"
	end
	print("Autoformatting " .. status)
end

return M
