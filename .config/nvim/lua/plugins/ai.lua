return {
	{
		"zbirenbaum/copilot.lua",
		branch = 'master',
		-- commit = "f0c0d98",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "InsertEnter",
		config = function()
			local copilot = require("copilot")
			local panel = require("copilot.panel")
			local suggestion = require("copilot.suggestion")

			copilot.setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
				copilot_model = 'gpt-4o-copilot',
				server_opts_overrides = {
					trace = "verbose",
					settings = {
						advanced = {
							inlineSuggestCount = 3, -- #completions for getCompletions
						},
					},
				},
			})

			vim.keymap.set('n', "<leader>csa", function() suggestion.accept() end, { desc = "Accept Copilot Suggestion" })
			vim.keymap.set('n', "<leader>csn", function() suggestion.next() end, { desc = "Next Copilot Suggestion" })
			vim.keymap.set('n', "csp", function() suggestion.prev() end, { desc = "Previous Copilot Suggestion" })
			vim.keymap.set('n', "cpa", function() panel.accept() end, { desc = "Accept Copilot Panel Suggestion" })
			vim.keymap.set('n', "cpn", function() panel.next() end, { desc = "Next Copilot Panel Suggestion" })
			vim.keymap.set('n', "cpp", function() panel.prev() end, { desc = "Previous Copilot Panel Suggestion" })
			vim.keymap.set('n', "cpo", function() panel.open() end, { desc = "Open Copilot Panel" })
			vim.keymap.set('n', "cpr", function() panel.refresh() end, { desc = "Refresh Copilot Panel" })
		end,
	},
	{
		"robitx/gp.nvim",
		config = function()
			require("gp").setup({
				providers = {
					openai = {},
					copilot = {
						endpoint = "https://api.githubcopilot.com/chat/completions",
						secret = {
							"bash",
							"-c",
							"cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'",
						},
					},
				},
				hooks = {
					CodeReview = function(gp, params)
						local template =
							"You are an expert software developer with a specialization in Javascript / Node.js functional programming. I have the following code from {{filename}}:\n\n"
							.. "```{{filetype}}\n{{selection}}\n```\n\n"
							.. "Please analyze for code smells and suggest improvements."
						local agent = gp.get_chat_agent()
						gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
					end,
					Commit = function(gp, params)
						local git_changes = vim.fn.system("git diff --staged")

						local template = "I have the following code changes in my git stage:\n\n" ..
							git_changes ..
							"\nPlease suggest a commit message. Do not explain or describe it in any way, just provide the commit message following the 'conventional commit' style."

						local agent = gp.get_chat_agent()
						gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
					end,
				}

			})

			local function keymapOptions(desc)
				return {
					noremap = true,
					silent = true,
					nowait = true,
					desc = "Prompt: " .. desc,
				}
			end

			vim.keymap.set({ "n", "i" }, "<C-g>cr", "<cmd>GpCodeReview<cr>", keymapOptions("Code Review"))
			vim.keymap.set({ "n", "i" }, "<C-g>cs", "<cmd>GpCommit<cr>", keymapOptions("Commit"))

			-- Chat commands
			vim.keymap.set({ "n", "i" }, "<C-g>cn", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
			vim.keymap.set({ "n", "i" }, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))
			vim.keymap.set({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))

			vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
			vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))
			vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat"))

			vim.keymap.set({ "n", "i" }, "<C-g><C-x>", "<cmd>GpChatNew split<cr>", keymapOptions("New Chat split"))
			vim.keymap.set({ "n", "i" }, "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", keymapOptions("New Chat vsplit"))
			vim.keymap.set({ "n", "i" }, "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", keymapOptions("New Chat tabnew"))

			vim.keymap.set("v", "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", keymapOptions("Visual Chat New split"))
			vim.keymap.set("v", "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptions("Visual Chat New vsplit"))
			vim.keymap.set("v", "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptions("Visual Chat New tabnew"))

			-- Prompt commands
			vim.keymap.set({ "n", "i" }, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions("Inline Rewrite"))
			vim.keymap.set({ "n", "i" }, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
			vim.keymap.set({ "n", "i" }, "<C-g>b", "<cmd>GpPrepend<cr>", keymapOptions("Prepend (before)"))

			vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual Rewrite"))
			vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
			vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", keymapOptions("Visual Prepend (before)"))
			vim.keymap.set("v", "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", keymapOptions("Implement selection"))

			vim.keymap.set({ "n", "i" }, "<C-g>gp", "<cmd>GpPopup<cr>", keymapOptions("Popup"))
			vim.keymap.set({ "n", "i" }, "<C-g>ge", "<cmd>GpEnew<cr>", keymapOptions("GpEnew"))
			vim.keymap.set({ "n", "i" }, "<C-g>gn", "<cmd>GpNew<cr>", keymapOptions("GpNew"))
			vim.keymap.set({ "n", "i" }, "<C-g>gv", "<cmd>GpVnew<cr>", keymapOptions("GpVnew"))
			vim.keymap.set({ "n", "i" }, "<C-g>gt", "<cmd>GpTabnew<cr>", keymapOptions("GpTabnew"))

			vim.keymap.set("v", "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", keymapOptions("Visual Popup"))
			vim.keymap.set("v", "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", keymapOptions("Visual GpEnew"))
			vim.keymap.set("v", "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", keymapOptions("Visual GpNew"))
			vim.keymap.set("v", "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", keymapOptions("Visual GpVnew"))
			vim.keymap.set("v", "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", keymapOptions("Visual GpTabnew"))

			vim.keymap.set({ "n", "i" }, "<C-g>x", "<cmd>GpContext<cr>", keymapOptions("Toggle Context"))
			vim.keymap.set("v", "<C-g>x", ":<C-u>'<,'>GpContext<cr>", keymapOptions("Visual Toggle Context"))

			vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions("Stop"))
			vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>n", "<cmd>GpNextAgent<cr>", keymapOptions("Next Agent"))

			-- optional Whisper commands with prefix <C-g>w
			vim.keymap.set({ "n", "i" }, "<C-g>ww", "<cmd>GpWhisper<cr>", keymapOptions("Whisper"))
			vim.keymap.set("v", "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", keymapOptions("Visual Whisper"))

			vim.keymap.set({ "n", "i" }, "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", keymapOptions("Whisper Inline Rewrite"))
			vim.keymap.set({ "n", "i" }, "<C-g>wa", "<cmd>GpWhisperAppend<cr>", keymapOptions("Whisper Append (after)"))
			vim.keymap.set({ "n", "i" }, "<C-g>wb", "<cmd>GpWhisperPrepend<cr>",
				keymapOptions("Whisper Prepend (before) "))

			vim.keymap.set("v", "<C-g>wr", ":<C-u>'<,'>GpWhisperRewrite<cr>", keymapOptions("Visual Whisper Rewrite"))
			vim.keymap.set("v", "<C-g>wa", ":<C-u>'<,'>GpWhisperAppend<cr>",
				keymapOptions("Visual Whisper Append (after)"))
			vim.keymap.set("v", "<C-g>wb", ":<C-u>'<,'>GpWhisperPrepend<cr>",
				keymapOptions("Visual Whisper Prepend (before)"))

			vim.keymap.set({ "n", "i" }, "<C-g>wp", "<cmd>GpWhisperPopup<cr>", keymapOptions("Whisper Popup"))
			vim.keymap.set({ "n", "i" }, "<C-g>we", "<cmd>GpWhisperEnew<cr>", keymapOptions("Whisper Enew"))
			vim.keymap.set({ "n", "i" }, "<C-g>wn", "<cmd>GpWhisperNew<cr>", keymapOptions("Whisper New"))
			vim.keymap.set({ "n", "i" }, "<C-g>wv", "<cmd>GpWhisperVnew<cr>", keymapOptions("Whisper Vnew"))
			vim.keymap.set({ "n", "i" }, "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", keymapOptions("Whisper Tabnew"))

			vim.keymap.set("v", "<C-g>wp", ":<C-u>'<,'>GpWhisperPopup<cr>", keymapOptions("Visual Whisper Popup"))
			vim.keymap.set("v", "<C-g>we", ":<C-u>'<,'>GpWhisperEnew<cr>", keymapOptions("Visual Whisper Enew"))
			vim.keymap.set("v", "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", keymapOptions("Visual Whisper New"))
			vim.keymap.set("v", "<C-g>wv", ":<C-u>'<,'>GpWhisperVnew<cr>", keymapOptions("Visual Whisper Vnew"))
			vim.keymap.set("v", "<C-g>wt", ":<C-u>'<,'>GpWhisperTabnew<cr>", keymapOptions("Visual Whisper Tabnew"))
		end,
	}
}
