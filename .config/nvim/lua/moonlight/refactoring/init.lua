return function()
	require("refactoring").setup({
		prompt_func_return_type = { go = true, cpp = true, c = true, java = true },
		prompt_func_param_type = { go = true, cpp = true, c = true, java = true },
	})

	local utils = require("moonlight.utils")
	local vmap = utils.vmap
	local refactor = require("refactoring").refactor

	local function extract_function()
		return refactor("Extract Function")
	end

	local function extract_function_to_file()
		return refactor("Extract Function To File")
	end

	local function extract_variable()
		return refactor("Extract Variable")
	end

	local function inline_variable()
		return refactor("Inline Variable")
	end

	local opts = { noremap = true, silent = true, expr = false }

	vmap("<space>re", extract_function, opts)
	vmap("<space>rf", extract_function_to_file, opts)
	vmap("<space>ev", extract_variable, opts)
	vmap("<space>iv", inline_variable, opts)
end
