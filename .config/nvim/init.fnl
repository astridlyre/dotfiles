(local vim _G.vim)

(require :moonlight.options)

;; Lazy.nvim setup
(local lazypath (.. (vim.fn.stdpath :data) :/lazy/lazy.nvim))

(when (not (vim.loop.fs_stat lazypath))
  (vim.fn.system [:git
                  :clone
                  "--filter=blob:none"
                  "https://github.com/folke/lazy.nvim.git"
                  :--branch=stable
                  lazypath]))

(vim.opt.rtp:prepend lazypath)

((. (require :lazy) :setup) :plugins
                            {:performance {:rtp {:disabled_plugins [:2html_plugin
                                                                    :getscript
                                                                    :getscriptPlugin
                                                                    :gzip
                                                                    :logiPat
                                                                    :matchit
                                                                    :matchparen
                                                                    :netrw
                                                                    :netrwPlugin
                                                                    :perl_provider
                                                                    :python_provider
                                                                    :rrhelper
                                                                    :ruby_provider
                                                                    :tar
                                                                    :tarPlugin
                                                                    :vimball
                                                                    :vimballPlugin
                                                                    :zip
                                                                    :zipPlugin]}}})

((. (require :luarocks) :add-luarocks-paths))

(require :moonlight.autocmds)
