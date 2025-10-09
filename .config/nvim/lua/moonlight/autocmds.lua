-- [nfnl] lua/moonlight/autocmds.fnl
local vim = _G.vim
local function augroup(name)
  return vim.api.nvim_create_augroup(("moonlight_" .. name), {clear = true})
end
local core = require("nfnl.core")
local function with_augroup(name, cmds, opts)
  return vim.api.nvim_create_autocmd(cmds, core.assoc(opts, {group = augroup(name)}))
end
local function _1_()
  if (vim.bo.filetype == "go") then
    return vim.api.nvim_buf_set_keymap(0, "i", ";;", ":=", {silent = true, desc = "Convert ;; to :="})
  else
    return nil
  end
end
with_augroup("golang", "FileType", {callback = _1_})
local function _3_()
  if (vim.bo.filetype == "qf") then
    vim.bo.buflisted = false
    return nil
  else
    return nil
  end
end
with_augroup("noqfixlisted", "FileType", {callback = _3_})
local function _5_()
  if (not vim.wo.cursorline and (vim.fn.win_gettype() ~= "popup") and not vim.wo.pvw) then
    vim.wo.cursorline = true
    return nil
  else
    return nil
  end
end
with_augroup("cursorline", {"WinEnter", "BufEnter", "InsertLeave"}, {callback = _5_})
local function _7_()
  if vim.wo.cursorline then
    vim.wo.cursorline = false
    return nil
  else
    return nil
  end
end
with_augroup("nocursorline", {"WinLeave", "BufLeave", "InsertEnter"}, {callback = _7_})
local function _9_()
  return vim.cmd("tabdo wincmd =")
end
with_augroup("winresize", "VimResized", {callback = _9_})
local function _10_(event)
  core["assoc-in"](vim.bo, {event.buf, "buflisted"}, false)
  return vim.api.nvim_buf_set_keymap(event.buf, "n", "q", "<Cmd>close<CR>", {silent = true, desc = "Close buffer"})
end
with_augroup("close_with_q", "FileType", {pattern = {"copilot", "help", "lspinfo", "man", "nofile", "notify", "PlenaryTestPopup", "prompt", "qf", "query", "spectre_panel", "startuptime", "terminal", "toggleterm", "tsplayground"}, callback = _10_})
local function _11_()
  vim.wo.wrap = true
  vim.wo.spell = true
  return nil
end
with_augroup("wrap_spell", "FileType", {pattern = {"gitcommit", "markdown"}, callback = _11_})
local function _12_()
  return vim.highlight.on_yank({higroup = "IncSearch", timeout = 200})
end
with_augroup("highlight_yank", "TextYankPost", {callback = _12_})
local function _13_(args)
  return core["assoc-in"](vim.b, {args.buf, "minipairs_disable"}, true)
end
return with_augroup("mini_disable_pairs", "FileType", {pattern = {"lazy", "mason", "scheme", "fennel", "clojure", "clojurec", "clojurescript", "clojurex", "edn", "lisp", "racket"}, callback = _13_})
