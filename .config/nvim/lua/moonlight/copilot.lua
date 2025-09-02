local M = {}

M.__copilot_enabled = true;

M.enabled = function()
	return M.__copilot_enabled
end

M.toggle = function()
	M.__copilot_enabled = not M.__copilot_enabled

	local message_for = function(state)
		if state then
			return "enabled"
		else
			return "disabled"
		end
	end

	print("Copilot", message_for(M.__copilot_enabled))

	return M.__copilot_enabled
end

return M
