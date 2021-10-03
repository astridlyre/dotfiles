local efm = {}
local enableTsServer = true

-- Vim linting
local vim_vint = {
	lintCommand = "vint -",
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
}

-- Markdown Lint & Formatting
local markdown = {
	lintCommand = "markdownlint -s",
	lintStdin = true,
	lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
	formatCommand = 'prettierd "${INPUT}"',
	formatStdin = true,
}

-- Yaml Linting
local yaml_lint = { lintCommand = "yamllint -f parsable -", lintStdin = true }

-- Shell formatting & linting
local shell = {
	lintCommand = "shellcheck -f gcc -x",
	lintSource = "shellcheck",
	lintFormats = {
		"%f:%l:%c: %trror: %m",
		"%f:%l:%c: %tarning: %m",
		"%f:%l:%c: %tote: %m",
	},
	formatCommand = "shfmt -ci -s -bn",
	formatStdin = true,
}

-- Lua formatting
local lua_fmt = { formatCommand = "stylua -", formatStdin = true }

-- Rust formatting
local rust_fmt = { formatCommand = "rustfmt --emit stdout", formatStdin = true }

-- Python formatting & Linting
local python_lint = {
	lintCommand = "mypy --show-column-numbers --disallow-untyped-calls --warn-return-any --warn-redundant-casts --warn-unused-ignores --disallow-untyped-defs --cache-dir=/dev/null",
	lintFormats = {
		"%f:%l:%c: %trror: %m",
		"%f:%l:%c: %tarning: %m",
		"%f:%l:%c: %tote: %m",
	},
	lintStdin = true,
}
local python_fmt = { formatCommand = "black --quiet -", formatStdin = true }
local python_isort = {
	formatCommand = "isort --profile black --quiet -",
	formatStdin = true,
}
local python_flake = {
	lintCommand = "flake8 --max-line-length 88 --extend-ignore E203 --stdin-display-name ${INPUT} -",
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
}

-- HTML Formatting
local html_fmt = {
	formatCommand = 'prettierd "${INPUT}"',
	formatStdin = true,
}

-- CSS Formatting
local css_fmt = { formatCommand = 'prettierd "${INPUT}"', formatStdin = true }

local eslint = {
	lintCommand = 'eslint_d --config /home/ml/.eslintrc.json -f unix --stdin --stdin-filename "${INPUT}"',
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
	lintIgnoreExitCode = true,
	formatCommand = 'prettierd "${INPUT}"',
	formatStdin = true,
}

-- JSON Formatting
local json = {
	formatCommand = "fixjson",
	lintCommand = "jq .",
	formatStdin = true,
	lintStdin = true,
}

if enableTsServer then
	efm.filetypes = {
		"css",
		"html",
		"json",
		"lua",
		"markdown",
		"python",
		"rust",
		"scss",
		"sh",
		"text",
		"vim",
		"yaml",
		"javascript",
		"javascriptreact",
	}

	efm.languages = {
		css = { css_fmt },
		html = { html_fmt },
		json = { json },
		lua = { lua_fmt },
		markdown = { markdown },
		python = { python_lint, python_isort, python_fmt, python_flake },
		rust = { rust_fmt },
		scss = { css_fmt },
		sh = { shell },
		vim = { vim_vint },
		yaml = { yaml_lint },
		javascript = { eslint },
	}
else
	efm.filetypes = {
		"css",
		"html",
		"json",
		"lua",
		"markdown",
		"python",
		"rust",
		"scss",
		"sh",
		"text",
		"vim",
		"yaml",
	}

	efm.languages = {
		css = { css_fmt },
		html = { html_fmt },
		json = { json },
		lua = { lua_fmt },
		markdown = { markdown },
		python = { python_lint, python_isort, python_fmt, python_flake },
		rust = { rust_fmt },
		scss = { css_fmt },
		sh = { shell },
		vim = { vim_vint },
		yaml = { yaml_lint },
	}
end

return efm
