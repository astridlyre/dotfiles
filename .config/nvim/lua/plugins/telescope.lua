return {
	{ "nvim-lua/plenary.nvim", lazy = true, version = false },
	{ "kyazdani42/nvim-web-devicons", lazy = true, version = false },
	{ "MunifTanjim/nui.nvim", lazy = true, version = false },
	{ "nvim-telescope/telescope-ui-select.nvim", version = false },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", version = false },
	{
		"nvim-telescope/telescope.nvim",
		version = false,
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		config = function()
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
							"--max-filesize",
							"1M",
							"--glob",
							"!*.{jpg,png,gif}",
						},
					},
				},
				extensions = {
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
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
		end,
	},
}
