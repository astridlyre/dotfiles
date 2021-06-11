local snap = require 'snap'
local fzf = snap.get 'consumer.fzf'
local producer_file = snap.get 'producer.ripgrep.file'
local select_file = snap.get 'select.file'
local preview_file = snap.get 'preview.file'
local s = {}

function s.files()
    snap.run({
        prompt = 'Files',
        producer = fzf(producer_file),
        select = select_file.select,
        multiselect = select_file.multiselect,
        views = {preview_file}
    })
end

return s
