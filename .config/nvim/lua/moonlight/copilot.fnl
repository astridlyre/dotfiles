(local M {})

(set M.__copilot_enabled true)

(set M.enabled (fn [] M.__copilot_enabled))

(fn message-for [state]
  (if state :enabled :disabled))

(set M.toggle (fn []
                (set M.__copilot_enabled (not M.__copilot_enabled))
                (print (.. "Copilot " (message-for M.__copilot_enabled)))
                M.__copilot_enabled))

M
