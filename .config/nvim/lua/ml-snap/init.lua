local snap = require 'snap'
local ignore_dirs = {
    "--hidden", "--iglob", "!**/.git/**", "--iglob", "!**/build/**", "--iglob",
    "!**/node_modules/**", "--iglob", "!**/vendor/bundle/**", "--iglob",
    "!**/.cache/**", "--iglob", "!**/.mypy_cache/**", "--iglob",
    "!**/.icons/**", "--iglob", "!**/.themes/**", "--iglob", "!Pictures/*",
    "--iglob", "!Videos/*"
}

local fzy = snap.get 'consumer.fzy'
local limit = snap.get 'consumer.limit'
local producer_file = snap.get 'producer.ripgrep.file'
local producer_vimgrep = snap.get 'producer.ripgrep.vimgrep'
local producer_buffer = snap.get 'producer.vim.buffer'
local producer_oldfile = snap.get 'producer.vim.oldfile'
local select_file = snap.get 'select.file'
local select_vimgrep = snap.get 'select.vimgrep'
local preview_file = snap.get 'preview.file'
local preview_vimgrep = snap.get 'preview.vimgrep'

local s = {}

function s.files()
    snap.run({
        prompt = 'Files ❱',
        producer = fzy(producer_file.args(ignore_dirs)),
        select = select_file.select,
        multiselect = select_file.multiselect,
        views = {preview_file}
    })
end

function s.grep()
    snap.run({
        prompt = 'Grep ❱',
        producer = limit(10000, producer_vimgrep),
        select = select_vimgrep.select,
        multiselect = select_vimgrep.multiselect,
        views = {preview_vimgrep}
    })
end

function s.buffers()
    snap.run({
        prompt = 'Buffers ❱',
        producer = fzy(producer_buffer),
        select = select_file.select,
        multiselect = select_file.multiselect,
        views = {preview_file}
    })
end

function s.oldfiles()
    snap.run({
        prompt = 'Oldfiles ❱',
        producer = fzy(producer_oldfile),
        select = select_file.select,
        multiselect = select_file.multiselect,
        views = {preview_file}
    })
end

return s
