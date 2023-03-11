return function()
	local copilot = require("copilot")
	local panel = require("copilot.panel")
	local suggestion = require("copilot.suggestion")
	local utils = require("moonlight.utils")
	local lmap = utils.lmap

	copilot.setup({
		suggestion = { enabled = false },
		panel = { enabled = false },
		server_opts_overrides = {
			trace = "verbose",
			settings = {
				advanced = {
					inlineSuggestCount = 3, -- #completions for getCompletions
				},
			},
		},
	})

	lmap("csa", function()
		suggestion.accept()
	end)

	lmap("csn", function()
		suggestion.next()
	end)

	lmap("csp", function()
		suggestion.prev()
	end)

	lmap("cpa", function()
		panel.accept()
	end)

	lmap("cpn", function()
		panel.next()
	end)

	lmap("cpp", function()
		panel.prev()
	end)

	lmap("cpo", function()
		panel.open()
	end)

	lmap("cpr", function()
		panel.refresh()
	end)
end
