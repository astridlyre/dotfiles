return {
	{
		"ggandor/leap.nvim",
		keys = {
			{ "<leader>j" },
			{ "<leader>k" },
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end

			vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
			vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

			local function leap_line(backward)
				require('leap').leap {
					pattern = '$',
					backward = backward,
					inputlen = 0,
					action = function(event)
						local target_line = event.pos[1]
						local current_line = vim.fn.getpos('.')[2]
						vim.cmd('norm! ' .. math.abs(target_line - current_line) .. (backward and 'k' or 'j'))
					end
				}
			end
			vim.keymap.set({ 'n', 'x', 'o' }, '<leader>j', function() leap_line(false) end, { desc = "Leap Down Lines" })
			vim.keymap.set({ 'n', 'x', 'o' }, '<leader>k', function() leap_line(true) end, { desc = "Leap Up Lines" })

			-- 1-character search (enhanced f/t motions)
			do
				-- Returns an argument table for `leap()`, tailored for f/t-motions.
				local function as_ft(key_specific_args)
					local common_args = {
						inputlen = 1,
						inclusive = true,
						-- To limit search scope to the current line:
						-- pattern = function (pat) return '\\%.l'..pat end,
						opts = {
							labels = '',                      -- force autojump
							safe_labels = vim.fn.mode(1):match('o') and '' or nil, -- [1]
							case_sensitive = true,            -- [2]
						},
					}
					return vim.tbl_deep_extend('keep', common_args, key_specific_args)
				end

				local clever = require('leap.user').with_traversal_keys -- [3]
				local clever_f = clever('f', 'F')
				local clever_t = clever('t', 'T')

				for key, args in pairs {
					f = { opts = clever_f, },
					F = { backward = true, opts = clever_f },
					t = { offset = -1, opts = clever_t },
					T = { backward = true, offset = 1, opts = clever_t },
				} do
					vim.keymap.set({ 'n', 'x', 'o' }, key, function()
						require('leap').leap(as_ft(args))
					end)
				end
			end

			------------------------------------------------------------------------
			-- [1] Match the modes here for which you don't want to use labels
			--     (`:h mode()`, `:h lua-pattern`).
			-- [2] For 1-char search, you might want to aim for precision instead of
			--     typing comfort, to get as many direct jumps as possible.
			-- [3] This helper function makes it easier to set "clever-f"-like
			--     functionality (https://github.com/rhysd/clever-f.vim), returning
			--     an `opts` table derived from the defaults, where:
			--     * the given keys are added to `keys.next_target` and
			--       `keys.prev_target`
			--     * the forward key is used as the first label in `safe_labels`
			--     * the backward (reverse) key is removed from `safe_labels`

			vim.keymap.set({ 'n', 'x', 'o' }, 'ga', function()
				require('leap.treesitter').select()
			end, { desc = "Leap to selection" })

			-- Linewise.
			vim.keymap.set({ 'n', 'x', 'o' }, 'gA',
				'V<cmd>lua require("leap.treesitter").select()<cr>',
				{ desc = "Leap to selection (linewise)" })
		end,
		version = false,
		event = { "BufReadPost", "BufNewFile" },
	},
}
