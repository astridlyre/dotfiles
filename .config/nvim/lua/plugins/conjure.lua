return {
	{
		'raystubbs/nvim-cljfmt-indents',
		config = function()
			require('nvim-cljfmt-indents').setup()

			vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
				pattern = { "*.clj", "*.cljs", "*.cljc", "*.edn" },
				callback = function(args)
					vim.o.indentexpr = "GetCljfmtIndent()"
				end
			})
		end
	},
	{
		"Olical/conjure",
		ft = { "clojure", "fennel", "python", "racket", "clojurescript" }, -- etc
		lazy = true,
		init = function()
			vim.g["conjure#mapping#doc_word"] = "gk"
		end
	},
	{ "Olical/nfnl", ft = "fennel" }
}
