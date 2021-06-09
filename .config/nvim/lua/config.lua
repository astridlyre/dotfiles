-- LSP and Completion
local completion = require('ml-completion')
completion.compe()
completion.telescope()
completion.autopairs()
completion.lsp_signature()
completion.matchup()

-- UI Components
local ui = require('ml-ui')
ui.lualine()
ui.colorizer()
ui.gitsigns()

-- Treesitter
local treesitter = require('ml-treesitter')
treesitter.configure()

-- Lsp
local lsp = require('lsp')
lsp.configure()
