(local vim _G.vim)
(local kmap vim.keymap.set)

;; -- Utils --
(fn get-diagnostic-at-cursor []
  "Get the diagnostic message at the current cursor position."
  (let [cur-buf (vim.api.nvim_get_current_buf)
        [line col] (vim.api.nvim_win_get_cursor 0)
        entries (vim.diagnostic.get cur-buf {:lnum (- line 1)})
        res {}]
    (each [_ v (pairs entries)]
      (when (and (<= v.col col) (>= v.end_col col))
        (table.insert res {:code v.code
                           :message v.message
                           :range {:start {:character v.col :line v.lnum}
                                   :end {:character v.end_col :line v.end_lnum}}
                           :severity v.severity
                           :source v.source})))
    res))

(fn lsp-maps [_ bufnr]
  (kmap :n :gD vim.lsp.buf.declaration
        {:buffer bufnr :desc "Go to declaration"})
  (kmap :n :gd vim.lsp.buf.definition {:buffer bufnr :desc "Go to definition"})
  (kmap :n :K vim.lsp.buf.hover {:buffer bufnr :desc "LSP hover"})
  (kmap :n :gi vim.lsp.buf.implementation
        {:buffer bufnr :desc "Go to implementation"})
  (kmap :n :gr vim.lsp.buf.references {:buffer bufnr :desc "Go to references"})
  (kmap :n :<leader>rn vim.lsp.buf.rename {:buffer bufnr :desc "LSP rename"})
  (kmap :n :<leader>qf vim.diagnostic.setqflist
        {:buffer bufnr :desc "Set quickfix from diagnostics"})
  (kmap :n :<leader>ca
        (fn []
          (vim.lsp.buf.code_action {:context {:diagnostics (get-diagnostic-at-cursor)}}))
        {:buffer bufnr :desc "LSP code action"})
  (kmap :n :<leader>ld
        (fn []
          (vim.diagnostic.open_float nil {:source :always :border :rounded}))
        {:buffer bufnr :desc "Show line diagnostics"})
  (kmap :n :<c-j>
        (fn []
          (vim.diagnostic.jump {:count 1 :float {:border :rounded}}))
        {:buffer bufnr :desc "Go to next diagnostic"})
  (kmap :n :<c-k>
        (fn []
          (vim.diagnostic.jump {:count -1 :float {:border :rounded}}))
        {:buffer bufnr :desc "Go to previous diagnostic"}))

(fn make-caps []
  (let [cmp (require :blink-cmp)]
    (cmp.get_lsp_capabilities (vim.lsp.protocol.make_client_capabilities))))

;; LSP Servers Config
(fn clangd []
  "Configure clangd LSP server with specific options."
  (vim.lsp.config :clangd {:cmd [:clangd
                                 :--background-index
                                 :--suggest-missing-includes
                                 :--clang-tidy
                                 :--header-insertion=iwyu]
                           :capabilities (make-caps)})
  (vim.lsp.enable [:clangd]))

(fn gopls []
  "Configure gopls LSP server with specific options."
  (vim.lsp.config :gopls {:settings {:gopls {:analyses {:unusedparams true
                                                        :shadow true}
                                             :staticcheck true
                                             :experimentalPostfixCompletions true}}
                          :init_options {:usePlaceholders true
                                         :completeUnimported true}
                          :capabilities (make-caps)})
  (vim.lsp.enable [:gopls]))

(fn rust-analyzer []
  "Configure rust-analyzer LSP server with specific options."
  (vim.lsp.config :rust_analyzer
                  {:capabilities (make-caps)
                   :settings {:rust-analyzer {:checkOnSave {:allFeatures true
                                                            :overrideCommand [:cargo
                                                                              :clippy
                                                                              :--workspace
                                                                              :--message-format=json
                                                                              :--all-targets
                                                                              :--all-features]}}}})
  (vim.lsp.enable [:rust_analyzer]))

(fn lua-ls []
  "Configure lua_ls LSP server with specific options."
  (let [library {}
        path (vim.split package.path ";")]
    (table.insert path :lua/?.lua)
    (table.insert path :lua/?/init.lua)

    (fn add [lib]
      (each [_ p (ipairs (vim.fn.expand lib false true))]
        (let [real (vim.loop.fs_realpath p)]
          (when real (tset library real true)))))

    (add :$VIMRUNTIME)
    (add "~/.config/nvim")
    (add "~/.local/share/nvim/lazy/*")
    (vim.lsp.config :lua_ls
                    {:capabilities (make-caps)
                     :on_new_config (fn [config root]
                                      (let [libs (vim.tbl_deep_extend :force {}
                                                                      library)]
                                        (tset libs root nil)
                                        (tset (. config :settings :Lua
                                                 :workspace)
                                              :library libs)
                                        config))
                     :settings {:Lua {:runtime {:version :LuaJIT : path}
                                      :completion {:callSnippet :Both}
                                      :diagnostics {:globals [:vim]}
                                      :workspace {: library
                                                  :maxPreload 2000
                                                  :preloadFileSize 50000
                                                  :checkThirdParty false}
                                      :telemetry {:enable false}}}})
    (vim.lsp.enable [:lua_ls])))

(fn ts-go []
  "Configure Typescript Go LSP server with specific options."
  (vim.lsp.config :ts-go {:cmd [(.. (os.getenv :HOME)
                                    :/projects/typescript-go/built/local/tsgo)
                                :--lsp
                                :-stdio]
                          :capabilities (make-caps)
                          :filetypes [:javascript
                                      :javascriptreact
                                      :javascript.jsx
                                      :typescript
                                      :typescriptreact
                                      :typescript.jsx]
                          :root_markers [:tsconfig.json
                                         :jsconfig.json
                                         :package.json
                                         :.git]})
  (vim.lsp.enable :ts-go))

;; Module setup
{:setup (fn []
          ;; default servers
          (let [default-servers [:pyright
                                 :yamlls
                                 :vimls
                                 :html
                                 :cssls
                                 :dockerls
                                 :bashls
                                 :clojure_lsp
                                 :eslint
                                 :zls
                                 :jsonls
                                 :astro
                                 :racket_langserver
                                 :fennel_ls
                                 :harper_ls]]
            (each [_ ls (ipairs default-servers)]
              (let [cfg {:capabilities (make-caps)}]
                (when (= ls :harper_ls)
                  (set cfg.filetypes [:gitcommit :markdown]))
                (vim.lsp.config ls cfg)
                (vim.lsp.enable [ls]))))
          ;; custom servers
          (each [_ f (ipairs [clangd gopls rust-analyzer lua-ls])]
            (f))
          ;; diagnostics config
          (let [signs {:text {}}]
            (tset (. signs :text) (. vim.diagnostic.severity :ERROR) "")
            (tset (. signs :text) (. vim.diagnostic.severity :WARN) "")
            (tset (. signs :text) (. vim.diagnostic.severity :INFO) "")
            (tset (. signs :text) (. vim.diagnostic.severity :HINT) "")
            (vim.diagnostic.config {:virtual_text false
                                    : signs
                                    :update_in_insert false
                                    :underline true
                                    :severity_sort true
                                    :float {:show_header false
                                            :focusable false
                                            :source :if_many
                                            :header ""
                                            :prefix ""}}))
          (vim.lsp.set_log_level :ERROR)
          (vim.api.nvim_create_autocmd :LspAttach
                                       {:callback (fn [args]
                                                    (let [bufnr args.buf
                                                          client (vim.lsp.get_client_by_id (. args.data
                                                                                              :client_id))]
                                                      (lsp-maps client bufnr)))}))}
