return function()
	-- Snippet Support
	local lsp = require("moonlight.lsp")
	local capabilities = lsp.make_capabilities()
	local flags = lsp.flags

	-- Null LS
	local null_ls = require("null-ls")
	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics

	null_ls.setup({
		sources = {
			formatting.raco_fmt,
			formatting.joker,
			formatting.prettierd,
			formatting.shfmt,
			formatting.black,
			formatting.fixjson,
			formatting.goimports,
			formatting.isort,
			formatting.fnlfmt,
			formatting.stylua,
			diagnostics.shellcheck,
			diagnostics.staticcheck,
			diagnostics.write_good.with({ filetypes = { "markdown", "tex", "text" } }),
			diagnostics.flake8,
			diagnostics.vint,
			diagnostics.yamllint,
		},
		capabilities = capabilities,
		flags = flags,
		on_attach = function(client)
			if client.server_capabilities.documentFormattingProvider then
				vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
				autocmd BufWritePre <buffer> lua require('moonlight.autoformat').format()
            augroup END
            ]])
			end
		end,
	})
end
