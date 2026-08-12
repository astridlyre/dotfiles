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
  kmap("n", "gD", vim.lsp.buf.declaration, {buffer = bufnr, desc = "Go to declaration"})
  kmap("n", "gd", vim.lsp.buf.definition, {buffer = bufnr, desc = "Go to definition"})
  kmap("n", "K", vim.lsp.buf.hover, {buffer = bufnr, desc = "LSP hover"})
  kmap("n", "gi", vim.lsp.buf.implementation, {buffer = bufnr, desc = "Go to implementation"})
  kmap("n", "gr", vim.lsp.buf.references, {buffer = bufnr, desc = "Go to references"})
  kmap("n", "<leader>rn", vim.lsp.buf.rename, {buffer = bufnr, desc = "LSP rename"})
  kmap("n", "<leader>qf", vim.diagnostic.setqflist, {buffer = bufnr, desc = "Set quickfix from diagnostics"})
  local function _3_()
    return vim.lsp.buf.code_action({context = {diagnostics = get_diagnostic_at_cursor()}})
  end
  kmap("n", "<leader>ca", _3_, {buffer = bufnr, desc = "LSP code action"})
  local function _4_()
    return vim.diagnostic.open_float(nil, {source = "always", border = "rounded"})
  end
  kmap("n", "<leader>ld", _4_, {buffer = bufnr, desc = "Show line diagnostics"})
  local function _5_()
    return vim.diagnostic.jump({count = 1, float = {border = "rounded"}})
  end
  kmap("n", "<c-j>", _5_, {buffer = bufnr, desc = "Go to next diagnostic"})
  local function _6_()
    return vim.diagnostic.jump({count = -1, float = {border = "rounded"}})
  end
  return kmap("n", "<c-k>", _6_, {buffer = bufnr, desc = "Go to previous diagnostic"})
end
local function make_caps()
  local cmp = require("blink-cmp")
  return cmp.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
end
local tsc_major_cache = {}
local function tsc_major(bin)
  if (nil == tsc_major_cache[bin]) then
    local ok, res
    local function _7_()
      return vim.system({bin, "--version"}, {text = true}):wait(5000)
    end
    ok, res = pcall(_7_)
    local major = (ok and (res.code == 0) and tonumber(string.match((res.stdout or ""), "(%d+)%.")))
    tsc_major_cache[bin] = (major or 0)
  else
  end
  return tsc_major_cache[bin]
end
local function resolve_tsc(root)
  local found = nil
  local function _9_()
    if root then
      return {vim.fs.joinpath(root, "node_modules/.bin/tsc"), "tsc"}
    else
      return {"tsc"}
    end
  end
  for _, bin in ipairs(_9_()) do
    if found then break end
    if ((1 == vim.fn.executable(bin)) and (tsc_major(bin) >= 7)) then
      found = bin
    else
    end
  end
  return (found or "tsgo")
end
local function tsc_cmd(dispatchers, config)
  local function _12_()
    local t_11_ = config
    if (nil ~= t_11_) then
      t_11_ = t_11_.root_dir
    else
    end
    return t_11_
  end
  return vim.lsp.rpc.start({resolve_tsc(_12_()), "--lsp", "--stdio"}, dispatchers)
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
  local function _15_(config, root)
    local libs = vim.tbl_deep_extend("force", {}, library)
    libs[root] = nil
    config.settings.Lua.workspace["library"] = libs
    return config
  end
  vim.lsp.config("lua_ls", {capabilities = make_caps(), on_new_config = _15_, settings = {Lua = {runtime = {version = "LuaJIT", path = path}, completion = {callSnippet = "Both"}, diagnostics = {globals = {"vim"}}, workspace = {library = library, maxPreload = 2000, preloadFileSize = 50000, checkThirdParty = false}, telemetry = {enable = false}}}})
  return vim.lsp.enable({"lua_ls"})
end
local function _16_(args)
  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if (client.name == "tsc") then
    local function _17_()
      return vim.lsp.buf.document_highlight()
    end
    vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {buffer = bufnr, callback = _17_})
    local function _18_()
      return vim.lsp.buf.clear_references()
    end
    vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {buffer = bufnr, callback = _18_})
    local function _19_()
      return vim.lsp.codelens.enable(true, {bufnr = bufnr})
    end
    vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {buffer = bufnr, callback = _19_})
    local function _20_()
      return vim.lsp.codelens.run()
    end
    kmap("n", "<leader>ll", _20_, {buffer = bufnr, desc = "Run code lens"})
    local function _21_()
      return vim.lsp.buf.incoming_calls()
    end
    kmap("n", "<leader>lc", _21_, {buffer = bufnr, desc = "Incoming calls"})
    local function _22_()
      return vim.lsp.buf.outgoing_calls()
    end
    kmap("n", "<leader>lC", _22_, {buffer = bufnr, desc = "Outgoing calls"})
    local function _23_()
      local enabled = vim.lsp.inlay_hint.is_enabled({bufnr = bufnr})
      return vim.lsp.inlay_hint.enable(not enabled, {bufnr = bufnr})
    end
    kmap("n", "<leader>lh", _23_, {buffer = bufnr, desc = "Toggle inlay hints"})
    local function _24_()
      return vim.lsp.buf.code_action({context = {only = {"source.organizeImports"}, diagnostics = {}}, apply = true})
    end
    kmap("n", "<leader>li", _24_, {buffer = bufnr, desc = "Organize imports"})
    local function _25_()
      return vim.lsp.buf.code_action({context = {only = {"source.removeUnusedImports"}, diagnostics = {}}, apply = true})
    end
    kmap("n", "<leader>lr", _25_, {buffer = bufnr, desc = "Remove unused imports"})
    local function _26_()
      return vim.lsp.buf.code_action({context = {only = {"source.sortImports"}, diagnostics = {}}, apply = true})
    end
    return kmap("n", "<leader>ls", _26_, {buffer = bufnr, desc = "Sort imports"})
  else
    return nil
  end
end
vim.api.nvim_create_autocmd("LspAttach", {callback = _16_})
local function _28_()
  do
    local default_servers = {"pyright", "yamlls", "vimls", "html", "cssls", "dockerls", "bashls", "clojure_lsp", "eslint", "zls", "jsonls", "astro", "racket_langserver", "jdtls", "fennel_ls", "tsc", "kotlin_lsp", "sourcekit"}
    for _, ls in ipairs(default_servers) do
      local cfg = {capabilities = make_caps()}
      if (ls == "tsc") then
        cfg.cmd = tsc_cmd
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
    local sev = vim.diagnostic.severity
    signs.text[sev.ERROR] = "\239\129\151"
    signs.text[sev.WARN] = "\239\129\177"
    signs.text[sev.INFO] = "\239\129\153"
    signs.text[sev.HINT] = "\239\129\154"
    vim.diagnostic.config({signs = signs, underline = true, severity_sort = true, float = {source = "if_many", header = "", prefix = "", focusable = false, show_header = false}, update_in_insert = false, virtual_text = false})
  end
  vim.lsp.log.set_level("ERROR")
  local function _30_(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    return lsp_maps(client, bufnr)
  end
  return vim.api.nvim_create_autocmd("LspAttach", {callback = _30_})
end
return {setup = _28_}
