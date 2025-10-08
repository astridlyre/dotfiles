-- [nfnl] lua/moonlight/lsp.fnl
local vim = _G.vim
local kmap = vim.keymap.set
local function get_diagnostic_at_cursor()
  local cur_buf = vim.api.nvim_get_current_buf()
  local _let_1_ = vim.api.nvim_win_get_cursor(0)
  local line = _let_1_[1]
  local col = _let_1_[2]
  local entries = vim.diagnostic.get(cur_buf, {lnum = (line - 1)})
  local res = {}
  for _, v in pairs(entries) do
    if ((v.col <= col) and (v.end_col >= col)) then
      table.insert(res, {code = v.code, message = v.message, range = {start = {character = v.col, line = v.lnum}, ["end"] = {character = v.end_col, line = v.end_lnum}}, severity = v.severity, source = v.source})
    else
    end
  end
  return res
end
local function lsp_maps(_, bufnr)
  local opts = {buffer = bufnr}
  kmap("n", "gD", vim.lsp.buf.declaration, opts)
  kmap("n", "gd", vim.lsp.buf.definition, opts)
  kmap("n", "K", vim.lsp.buf.hover, opts)
  kmap("n", "gi", vim.lsp.buf.implementation, opts)
  kmap("n", "gr", vim.lsp.buf.references, opts)
  kmap("n", "<leader>rn", vim.lsp.buf.rename, opts)
  kmap("n", "<leader>qf", vim.diagnostic.setqflist, opts)
  local function _3_()
    return vim.lsp.buf.code_action({context = {diagnostics = get_diagnostic_at_cursor()}})
  end
  kmap("n", "<leader>ca", _3_)
  local function _4_()
    return vim.diagnostic.open_float(nil, {source = "always", border = "rounded"})
  end
  kmap("n", "<leader>ld", _4_)
  local function _5_()
    return vim.diagnostic.jump({count = 1, float = {border = "rounded"}})
  end
  kmap("n", "<c-j>", _5_)
  local function _6_()
    return vim.diagnostic.jump({count = -1, float = {border = "rounded"}})
  end
  return kmap("n", "<c-k>", _6_)
end
local function make_caps()
  local cmp = require("blink-cmp")
  return cmp.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
end
local function clangd()
  vim.lsp.config("clangd", {cmd = {"clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy", "--header-insertion=iwyu"}, capabilities = make_caps()})
  return vim.lsp.enable({"clangd"})
end
local function gopls()
  vim.lsp.config("gopls", {settings = {gopls = {analyses = {unusedparams = true, shadow = true}, staticcheck = true, experimentalPostfixCompletions = true}}, init_options = {usePlaceholders = true, completeUnimported = true}, capabilities = make_caps()})
  return vim.lsp.enable({"gopls"})
end
local function rust_analyzer()
  vim.lsp.config("rust_analyzer", {capabilities = make_caps(), settings = {["rust-analyzer"] = {checkOnSave = {allFeatures = true, overrideCommand = {"cargo", "clippy", "--workspace", "--message-format=json", "--all-targets", "--all-features"}}}}})
  return vim.lsp.enable({"rust_analyzer"})
end
local function lua_ls()
  local library = {}
  local path = vim.split(package.path, ";")
  table.insert(path, "lua/?.lua")
  table.insert(path, "lua/?/init.lua")
  local function add(lib)
    for _, p in ipairs(vim.fn.expand(lib, false, true)) do
      local real = vim.loop.fs_realpath(p)
      if real then
        library[real] = true
      else
      end
    end
    return nil
  end
  add("$VIMRUNTIME")
  add("~/.config/nvim")
  add("~/.local/share/nvim/lazy/*")
  local function _8_(config, root)
    local libs = vim.tbl_deep_extend("force", {}, library)
    libs[root] = nil
    config.settings.Lua.workspace["library"] = libs
    return config
  end
  vim.lsp.config("lua_ls", {capabilities = make_caps(), on_new_config = _8_, settings = {Lua = {runtime = {version = "LuaJIT", path = path}, completion = {callSnippet = "Both"}, diagnostics = {globals = {"vim"}}, workspace = {library = library, maxPreload = 2000, preloadFileSize = 50000, checkThirdParty = false}, telemetry = {enable = false}}}})
  return vim.lsp.enable({"lua_ls"})
end
local function _9_()
  do
    local default_servers = {"pyright", "yamlls", "vimls", "html", "cssls", "dockerls", "bashls", "clojure_lsp", "eslint", "zls", "jsonls", "astro", "racket_langserver", "fennel_ls", "harper_ls"}
    for _, ls in ipairs(default_servers) do
      local cfg = {capabilities = make_caps()}
      if (ls == "harper_ls") then
        cfg.filetypes = {"gitcommit", "markdown"}
      else
      end
      vim.lsp.config(ls, cfg)
      vim.lsp.enable({ls})
    end
  end
  for _, f in ipairs({clangd, gopls, rust_analyzer, lua_ls}) do
    f()
  end
  do
    local signs = {text = {}}
    signs.text[vim.diagnostic.severity.ERROR] = "\239\129\151"
    signs.text[vim.diagnostic.severity.WARN] = "\239\129\177"
    signs.text[vim.diagnostic.severity.INFO] = "\239\129\153"
    signs.text[vim.diagnostic.severity.HINT] = "\239\129\154"
    vim.diagnostic.config({signs = signs, underline = true, severity_sort = true, float = {source = "if_many", header = "", prefix = "", focusable = false, show_header = false}, update_in_insert = false, virtual_text = false})
  end
  vim.lsp.set_log_level("OFF")
  local function _11_(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    return lsp_maps(client, bufnr)
  end
  return vim.api.nvim_create_autocmd("LspAttach", {callback = _11_})
end
return {setup = _9_}
