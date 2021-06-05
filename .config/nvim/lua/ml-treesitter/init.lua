-- Treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {enable = true},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<M-w>',
            node_incremental = '<M-w>',
            scope_incremental = '<M-e>',
            node_decremental = '<M-C-w>'
        }
    },
    autotag = {enable = true},
    autopairs = {enable = true},
    matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        disable = {"sh"} -- optional, list of language that will be disabled
    }
}
