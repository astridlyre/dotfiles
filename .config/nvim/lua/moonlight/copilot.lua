-- [nfnl] lua/moonlight/copilot.fnl
local vim = _G.vim
local copilot_enabled = true
local function enabled()
  return copilot_enabled
end
local function message_for(state)
  if state then
    return "enabled"
  else
    return "disabled"
  end
end
local function toggle_copilot()
  copilot_enabled = not copilot_enabled
  if copilot_enabled then
    vim.cmd("Copilot enable")
  else
    vim.cmd("Copilot disable")
  end
  print(("Copilot " .. message_for(copilot_enabled)))
  return copilot_enabled
end
return {enabled = enabled, ["toggle-copilot"] = toggle_copilot}
