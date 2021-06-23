local ts = {}

-- Treesitter
function ts.configure()
    require'nvim-treesitter.configs'.setup {
        ensure_installed = "maintained",
        highlight = {enable = true},
        indent = {enable = true},
        textsubjects = {enable = true, keymaps = {['.'] = 'textsubjects-smart'}},
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ['aa'] = '@parameter.outer',
                    ['ia'] = '@parameter.inner',
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner'
                }
            },
            swap = {
                enable = true,
                swap_next = {['<leader>a'] = '@parameter.inner'},
                swap_previous = {['<leader>A'] = '@parameter.inner'}
            }
        },
        autotag = {enable = true},
        autopairs = {enable = true},
        matchup = {
            enable = false, -- mandatory, false will disable the whole extension
            disable = {"sh"} -- optional, list of language that will be disabled
        }
    }
end

return ts
