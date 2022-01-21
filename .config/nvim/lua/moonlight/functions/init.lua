local M = {}

local utils = require("moonlight.utils")
local lmap = utils.lmap
local nmap = utils.nmap

function M.setup()
	local runners = {
		javascript = { run = "pnpm run dev", test = "pnpm run test" },
		typescript = { run = "pnpm run dev", test = "pnpm run test" },
		rust = { run = "cargo run", test = "cargo test" },
		clojure = {
			run = 'clj -m nrepl.cmdline --middleware "[cider.nrepl/cider-middleware]" --interactive',
			test = "",
		},
		clojurescript = { run = "pnpx shadow-cljs watch app", test = "pnpx shadow-cljs test app" },
	}

	local function run_task(term, variant)
		return function()
			local file_type = vim.bo.filetype
			local runner = runners[file_type]

			if not runner then
				return
			end

			return vim.cmd(term .. "TermExec cmd='" .. runner[variant] .. "'")
		end
	end

	-- Task Runners
	lmap("r", run_task(1, "run"))
	lmap("t", run_task(2, "test"))

	local showing_qf = false
	local function toggle_qf_list()
		if showing_qf then
			showing_qf = false
			vim.cmd("cclose")
		else
			showing_qf = true
			vim.cmd("copen")
		end
	end

	nmap("<c-q>", toggle_qf_list)
end

return M
