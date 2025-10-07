-- [nfnl] lua/moonlight/copilot.fnl
local M = {}
M.__copilot_enabled = true
local function _1_()
  return M.__copilot_enabled
end
M.enabled = _1_
local function message_for(state)
  if state then
    return "enabled"
  else
    return "disabled"
  end
end
local function _3_()
  M.__copilot_enabled = not M.__copilot_enabled
  print(("Copilot " .. message_for(M.__copilot_enabled)))
  return M.__copilot_enabled
end
M.toggle = _3_
return M
