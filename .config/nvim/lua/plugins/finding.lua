return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		---@type snacks.Config
		opts = {
			picker = { enabled = true },
			bigfile = { enabled = true },
			explorer = { enabled = true, replace_netrw = true },
			input = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			bufdelete = { enabled = true },
		},
		keys = {
			{ "<leader>d",  function() Snacks.bufdelete.delete() end,             desc = 'Buf Delete' },
			{ "<leader>o",  function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
			{ "<leader>,",  function() Snacks.picker.buffers() end,               desc = "Buffers" },
			{ "<leader>/",  function() Snacks.picker.grep() end,                  desc = "Grep" },
			{ "<leader>fg", function() Snacks.picker.git_files() end,             desc = "Find Git Files" },
			{ "<leader>gs", function() Snacks.picker.git_status() end,            desc = "Git Status" },
			{ "<leader>gS", function() Snacks.picker.git_stash() end,             desc = "Git Stash" },
			{ "<leader>gd", function() Snacks.picker.git_diff() end,              desc = "Git Diff (Hunks)" },
			{ "<leader>gb", function() Snacks.picker.git_branches() end,          desc = "Git Branches" },
			{ "<leader>fh", function() Snacks.picker.help() end,                  desc = "Help Pages" },
			{ "<leader>sq", function() Snacks.picker.qflist() end,                desc = "Quickfix List" },
			{ "<leader>fd", function() Snacks.picker.diagnostics_buffer() end,    desc = "Find Diagnostics" },
			{ "<leader>ss", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
			{ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
			{ "<leader>fi", function() Snacks.picker.icons() end,                 desc = "Find Icons" },
			{ "<leader>e",  function() Snacks.explorer() end }
		}
	}
}
