return require('packer').startup(function(use)
    -- use 'wbthomason/packer.nvim'

    local ui = require('ml-ui')
    use {'astridlyre/falcon', config = vim.cmd('colorscheme falcon')}
    use {'hoob3rt/lualine.nvim', config = ui.lualine()}
    use {
        'norcalli/nvim-colorizer.lua',
        config = ui.colorizer(),
        event = 'BufRead'
    }
    use {'camspiers/snap', rocks = {'fzy'}}
    use 'junegunn/vim-easy-align'
    use 'b3nj5m1n/kommentary'
    use 'tpope/vim-fugitive'
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        event = {'BufRead', 'BufNewFile'}
    }

    local ts = require('ml-treesitter')
    use {
        'nvim-treesitter/nvim-treesitter',
        config = ts.configure(),
        event = 'BufRead',
        run = ':TSUpdate'
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter'
    }
    use {'RRethy/nvim-treesitter-textsubjects', after = 'nvim-treesitter'}
    use {'andymass/vim-matchup', after = 'nvim-treesitter'}
    use {'windwp/nvim-ts-autotag', after = 'nvim-treesitter'}

    local lsp = require('lsp')
    use {
        'neovim/nvim-lspconfig',
        config = lsp.configure(),
        event = 'BufReadPre'
    }

    local completion = require('ml-completion')
    use {
        'hrsh7th/nvim-compe',
        config = completion.compe(),
        event = 'InsertEnter'
    }
    use {'ray-x/lsp_signature.nvim', config = completion.lsp_signature()}
    use {'windwp/nvim-autopairs', config = completion.autopairs()}
    use {
        'hrsh7th/vim-vsnip',
        event = 'InsertCharPre',
        requires = {'hrsh7th/vim-vsnip-integ', 'rafamadriz/friendly-snippets'}
    }
end)
