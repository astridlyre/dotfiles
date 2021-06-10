-- LSP and Completion
function _G.reload_lsp()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.cmd [[edit]]
end
vim.cmd('command! -nargs=0 LspRestart call v:lua.reload_lsp()')

local completion = require('ml-completion')
completion.compe()
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
