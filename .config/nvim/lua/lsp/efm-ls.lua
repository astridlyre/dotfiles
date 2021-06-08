-- Vim Linting
local vim_vint = {
    lintCommand = 'vint -',
    lintStdin = true,
    lintFormats = {'%f:%l:%c: %m'}
}

-- Markdown Lint & Formatting
local markdown = {
    lintCommand = 'markdownlint -s',
    lintStdin = true,
    lintFormats = {'%f:%l %m', '%f:%l:%c %m', '%f: %l: %m'},
    formatCommand = 'prettier --parser markdown',
    formatStdin = true
}

-- Text Linting
local txt = {lintCommand = 'write-good --parse', lintFormats = {'%f:%l:%c:%m'}}

-- Yaml Linting
local yaml_lint = {lintCommand = 'yamllint -f parsable -', lintStdin = true}

-- Shell formatting & linting
local shell = {
    lintCommand = 'shellcheck -f gcc -x',
    lintSource = 'shellcheck',
    lintFormats = {
        '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'
    },
    formatCommand = 'shfmt -ci -s -bn',
    formatStdin = true
}

-- Lua formatting
local lua_fmt = {formatCommand = 'lua-format -i', formatStdin = true}

-- Rust formatting
local rust_fmt = {formatCommand = 'rustfmt --emit stdout', formatStdin = true}

-- Python formatting & Linting
local python_lint = {
    lintCommand = 'mypy --show-column-numbers',
    lintFormats = {
        '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'
    },
    lintStdin = true
}
local python_fmt = {formatCommand = 'black --quiet -', formatStdin = true}
local python_isort = {formatCommand = 'isort --quiet -', formatStdin = true}
local python_flake = {
    lintCommand = 'flake8 --stdin-display-name ${INPUT} -',
    lintStdin = true,
    lintFormats = {'%f:%l:%c: %m'}
}

-- HTML Formatting
local html_fmt = {formatCommand = 'prettier --parser html', formatStdin = true}

-- CSS Formatting
local css_fmt = {formatCommand = 'prettier --parser css', formatStdin = true}

-- JSON Formatting
local json = {
    formatCommand = 'fixjson',
    lintCommand = 'jq .',
    formatStdin = true,
    lintStdin = true
}

-- EFM Server Setup
require"lspconfig".efm.setup {
    init_options = {
        documentFormatting = true,
        hover = false,
        documentSymbol = false,
        codeAction = false,
        completion = false
    },
    root_dir = function() return vim.fn.getcwd() end,
    filetypes = {
        "sh", "rust", "vim", "lua", "python", "yaml", "markdown", "html", "css",
        "sass", "json", "text"
    },
    settings = {
        rootMarkers = {".git/"},
        languages = {
            vim = {vim_vint},
            markdown = {markdown},
            yaml = {yaml_lint},
            sh = {shell},
            lua = {lua_fmt},
            rust = {rust_fmt},
            python = {python_lint, python_fmt, python_isort, python_flake},
            json = {json},
            html = {html_fmt},
            css = {css_fmt},
            sass = {css_fmt},
            text = {txt}
        }
    }
}
