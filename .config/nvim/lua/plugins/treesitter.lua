local languages = {
	'astro',
	'bash',
	'c',
	'clojure',
	'cmake',
	'css',
	'csv',
	'diff',
	'dockerfile',
	'fennel',
	'gitattributes',
	'gitcommit',
	'git_config',
	'gitignore',
	'git_rebase',
	'go',
	'gomod',
	'gosum',
	'gotmpl',
	'gpg',
	'graphql',
	'haskell',
	'html',
	'http',
	'javascript',
	'jq',
	'jsdoc',
	'json',
	'json5',
	'jsx',
	'latex',
	'lua',
	'luadoc',
	'make',
	'markdown',
	'nginx',
	'passwd',
	'python',
	'racket',
	'regex',
	'rust',
	'scss',
	'sql',
	'styled',
	'templ',
	'terraform',
	'toml',
	'tsv',
	'tsx',
	'typescript',
	'vim',
	'vimdoc',
	'xml',
	'xresources',
	'yaml',
	'zathurarc',
	'zig'
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = 'main',
		lazy = false,
		version = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install(languages)
			require('moonlight.incremental.init').setup({
				enable = true,
				disable = false,
				keymaps = {
					init_selection = '<Enter>',
					node_incremental = '<Enter>',
					scope_incremental = '<Tab>',
					node_decremental = '<S-Enter>',
				}
			})

			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('treesitter.setup', {}),
				callback = function(args)
					local buf = args.buf
					local filetype = args.match

					-- you need some mechanism to avoid running on buffers that do not
					-- correspond to a language (like oil.nvim buffers), this implementation
					-- checks if a parser exists for the current language
					local language = vim.treesitter.language.get_lang(filetype) or filetype
					if not vim.treesitter.language.add(language) then
						return
					end

					-- replicate `fold = { enable = true }`
					-- vim.wo.foldmethod = 'expr'
					-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

					-- replicate `highlight = { enable = true }`
					vim.treesitter.start(buf, language)

					-- replicate `indent = { enable = true }`
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

					local incremental = require("moonlight.incremental.init")
					incremental.attach({
						buf = buf,
						language = language
					})

					local autoclosetag = require("moonlight.autoclosetag.init")
					autoclosetag.setup()
				end,
			})
		end,
	},
}
