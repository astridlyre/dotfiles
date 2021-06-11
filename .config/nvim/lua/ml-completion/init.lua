local completion = {}

-- Compe setup
function completion.compe()
    require'compe'.setup {
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = 'enable',
        throttle_time = 80,
        source_timeout = 200,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,
        allow_prefix_unmatch = false,
        source = {
            path = {kind = "   "},
            buffer = {kind = "   "},
            nvim_lsp = {kind = "   "},
            vsnip = {kind = "   "},
            spell = {kind = "   "},
            calc = {kind = "   "}
        }
    }
end

-- autopairs
function completion.autopairs()
    require('nvim-autopairs').setup()
    local remap = vim.api.nvim_set_keymap
    local npairs = require('nvim-autopairs')

    _G.MUtils = {}
    vim.g.completion_confirm_key = ""
    MUtils.completion_confirm = function()
        if vim.fn.pumvisible() ~= 0 then
            if vim.fn.complete_info()["selected"] ~= -1 then
                return vim.fn["compe#confirm"](npairs.esc("<cr>"))
            else
                return npairs.esc("<cr>")
            end
        else
            return npairs.autopairs_cr()
        end
    end

    npairs.setup({
        check_ts = true,
        ts_config = {lua = {'string'}, javascript = {'template_string'}}
    })

    remap('i', '<CR>', 'v:lua.MUtils.completion_confirm()',
          {expr = true, noremap = true})
end

-- Function signatures as you type
function completion.lsp_signature()
    local cfg = {
        bind = true,
        doc_lines = 2,
        floating_window = true,
        hint_enable = true,
        hint_prefix = '❱ ',
        hint_scheme = "String",
        use_lspsaga = false,
        hi_parameter = "Search",
        max_height = 12,
        max_width = 120,
        handler_opts = {border = "single"},
        extra_trigger_chars = {}
    }
    require'lsp_signature'.on_attach(cfg)
end

-- Matchup
function completion.matchup()
    vim.g.matchup_matchparen_offscreen = {method = 'popup'}
end

return completion
