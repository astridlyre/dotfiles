return {
	{ "nvim-lua/plenary.nvim",                      lazy = true, version = false },
	{ "nvim-telescope/telescope-file-browser.nvim", lazy = true, version = false },
	{
		"nvim-telescope/telescope.nvim",
		lazy = false,
		version = false,
		dependencies = {
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
			{ "kyazdani42/nvim-web-devicons",             lazy = true,                                                                                   version = false },
			"nvim-telescope/telescope-live-grep-args.nvim" },
		config = function()
			local lga_actions = require("telescope-live-grep-args.actions")
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					prompt_prefix = "❯ ",
					selection_caret = "  ",
					path_display = { "smart" },
					sorting_strategy = "ascending",
					layout_strategy = "flex",
					layout_config = {
						horizontal = { prompt_position = "top", preview_width = 0.55 },
						vertical = { mirror = false },
						width = 0.87,
						height = 0.8,
						preview_cutoff = 120,
					},
					dynamic_preview_title = true,
					preview = {
						filesize_hook = function(filepath, bufnr, opts)
							local max_bytes = 10000
							local cmd = { "head", "-c", max_bytes, filepath }
							require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
						end,
					},
				},
				pickers = {
					find_files = {
						find_command = {
							"rg",
							"--files",
							"--hidden",
							"--glob",
							"!**/node_modules/**",
							"--glob",
							"!**/build/**",
							"--glob",
							"!**/.git/**",
							"--glob",
							"!**/.cache/**",
							"--glob",
							"!**/.mypy_cache/**",
							"--glob",
							"!**/dist/**",
							"--glob",
							"!**/.parcel-cache/**",
							"--glob",
							"!*.min.js",
							"--glob",
							"!**/db-init/**",
							"--max-filesize",
							"1M",
							"--glob",
							"!*.{jpg,png,gif}",
						},
					},
				},
				extensions = {
					live_grep_args = {
						auto_quoting = true, -- enable/disable auto-quoting
						-- define mappings, e.g.
						mappings = {
							-- extend mappings
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
								["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob **/db-init/**" }),
							},
						},
					},
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					file_browser = {
						previewer = false,
						theme = "ivy",
						hijack_netrw = true,
						initial_mode = "insert",
						git_status = true,
						mappings = {
							i = {
								["<esc>"] = false,
							},
						},
					},
				},
			})
			telescope.load_extension("fzf")

			local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
			vim.keymap.set("n", "gw", live_grep_args_shortcuts.grep_word_under_cursor)
			vim.keymap.set("v", "gw", live_grep_args_shortcuts.grep_visual_selection)
			vim.keymap.set("n", "<c-n>", function()
				require("telescope").extensions.file_browser.file_browser()
			end)
			vim.keymap.set("n", "<space>lg", function()
				require("telescope").extensions.live_grep_args.live_grep_args()
			end)
		end,
	},
}
