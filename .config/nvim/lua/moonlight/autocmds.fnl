(local vim _G.vim)

(fn augroup [name]
  (vim.api.nvim_create_augroup (.. :moonlight_ name) {:clear true}))

(local core (require :nfnl.core))

(fn with-augroup [name cmds opts]
  (vim.api.nvim_create_autocmd cmds (core.assoc opts {:group (augroup name)})))

;; Convert ;; into := for Go files
(with-augroup :golang
  :FileType
  {:callback (fn []
               (when (= vim.bo.filetype :go)
                 (vim.api.nvim_buf_set_keymap 0 :i ";;" ":="
                                              {:silent true
                                               :desc "Convert ;; to :="})))})

;; Make quickfix buffers not show in buffer list
(with-augroup :noqfixlisted
  :FileType
  {:callback (fn []
               (when (= vim.bo.filetype :qf)
                 (set vim.bo.buflisted false)))})

;; Enable cursorline only in the active window
(with-augroup :cursorline
  [:WinEnter :BufEnter :InsertLeave]
  {:callback (fn []
               (when (and (not vim.wo.cursorline)
                          (not= (vim.fn.win_gettype) :popup) (not vim.wo.pvw))
                 (set vim.wo.cursorline true)))})

;; Disable cursorline in inactive windows
(with-augroup :nocursorline
  [:WinLeave :BufLeave :InsertEnter]
  {:callback (fn []
               (when vim.wo.cursorline
                 (set vim.wo.cursorline false)))})

;; Equalize window sizes when resizing Vim window
(with-augroup :winresize
  :VimResized
  {:callback (fn []
               (vim.cmd "tabdo wincmd ="))})

;; Close certain filetypes with 'q'
(with-augroup :close_with_q
  :FileType
  {:pattern [:copilot
             :help
             :lspinfo
             :man
             :nofile
             :notify
             :PlenaryTestPopup
             :prompt
             :qf
             :query
             :spectre_panel
             :startuptime
             :terminal
             :toggleterm
             :tsplayground]
   :callback (fn [event]
               (core.assoc-in vim.bo [event.buf :buflisted] false)
               (vim.api.nvim_buf_set_keymap event.buf :n :q :<Cmd>close<CR>
                                            {:silent true :desc "Close buffer"}))})

;; Wrap and spell check for certain filetypes
(with-augroup :wrap_spell
  :FileType
  {:pattern [:gitcommit :markdown]
   :callback (fn []
               (set vim.wo.wrap true)
               (set vim.wo.spell true))})

;; Highlight yanked text
(with-augroup :highlight_yank
  :TextYankPost
  {:callback (fn [] (vim.highlight.on_yank {:higroup :IncSearch :timeout 200}))})
