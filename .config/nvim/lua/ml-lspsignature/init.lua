-- Function signatures as you type
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
