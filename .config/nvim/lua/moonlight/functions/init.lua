local M = {}

local utils = require("moonlight.utils")
local lmap = utils.lmap
local nmap = utils.nmap

local go_lang = function(filename)
	return {
		run = "go run " .. filename,
		test = "go test",
	}
end

local javascript = function(_)
	return {
		run = "pnpm run dev",
		test = "pnpm run test",
	}
end

local clojure = function(_)
	return {
		run = 'clj -m nrepl.cmdline --middleware "[cider.nrepl/cider-middleware]" --interactive',
		test = "",
	}
end

local racket = function(filename)
	return {
		run = "racket " .. filename,
		test = "raco test " .. filename,
	}
end

local clojurescript = function(_)
	return {
		run = "pnpx shadow-cljs watch app",
		test = "pnpx shadow-cljs test app",
	}
end

local rust = function(_)
	return {
		run = "cargo run",
		test = "cargo test",
	}
end

function M.setup()
	local runners = {
		javascript = javascript,
		javascriptreact = javascript,
		typescript = javascript,
		typescriptreact = javascript,
		rust = rust,
		clojure = clojure,
		clojurescript = clojurescript,
		racket = racket,
		go = go_lang,
	}

	local function run_task(term, variant)
		return function()
			local file_type = vim.bo.filetype
			local runner = runners[file_type](vim.api.nvim_buf_get_name(0))

			if not runner then
				return
			end

			return vim.cmd(term .. "TermExec cmd='" .. runner[variant] .. "'")
		end
	end

	-- Task Runners
	lmap("r", run_task(1, "run"))
	lmap("t", run_task(2, "test"))

	-- toggle quickfix
	vim.g.qfix_win = nil
	local function toggle_qf_list()
		if vim.g.qfix_win ~= nil then
			vim.cmd("cclose")
			vim.g.qfix_win = nil
		else
			vim.cmd("copen")
		end
	end

	vim.cmd([[
augroup QFixToggle
	autocmd!
	autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
augroup END
	]])

	nmap("<c-q>", toggle_qf_list)
end

return M
