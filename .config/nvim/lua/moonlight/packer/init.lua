local M = {}
local execute = vim.api.nvim_command
local fn = vim.fn

M.install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
M.compile_path = fn.stdpath("config") .. "/lua/packer_compiled.lua"

function M.setup()
	if fn.empty(vim.fn.glob(M.install_path)) > 0 then
		fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", M.install_path })
		execute("packadd packer.nvim")
	end

	-- Handle errors
	local require_plugin = function(p)
		local ok, plugin = pcall(require, p)
		if ok then
			return plugin
		else
			print("Unable to load " .. p)
			return nil
		end
	end

	-- Packer Configuration
	local packer = require_plugin("packer")
	local util = require_plugin("packer.util")
	local packer_init = {
		display = {
			open_fn = function()
				if util ~= nil then
					return util.float({ border = "rounded" })
				end
			end,
		},
	}

	if packer ~= nil then
		packer.init(packer_init)
	end

	return packer
end

return M
