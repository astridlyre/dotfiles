(local vim _G.vim)

(var copilot-enabled true)

(fn enabled []
  "Returns whether Copilot is enabled"
  copilot-enabled)

(fn message-for [state]
  (if state :enabled :disabled))

(fn toggle-copilot []
  "Toggles Copilot on and off, printing a message to indicate the new state"
  (set copilot-enabled (not copilot-enabled))
  (if copilot-enabled (vim.cmd "Copilot enable") (vim.cmd "Copilot disable"))
  (print (.. "Copilot " (message-for copilot-enabled)))
  copilot-enabled)

{: enabled : toggle-copilot}
