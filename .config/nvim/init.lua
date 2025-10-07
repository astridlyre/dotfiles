-- [nfnl] init.fnl
local vim = _G.vim
require("moonlight.options")
local lazypath = (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath})
else
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {performance = {rtp = {disabled_plugins = {"2html_plugin", "getscript", "getscriptPlugin", "gzip", "logiPat", "matchit", "matchparen", "netrw", "netrwPlugin", "perl_provider", "python_provider", "rrhelper", "ruby_provider", "tar", "tarPlugin", "vimball", "vimballPlugin", "zip", "zipPlugin"}}}})
require("luarocks").add_luarocks_paths()
return require("moonlight.autocmds")
