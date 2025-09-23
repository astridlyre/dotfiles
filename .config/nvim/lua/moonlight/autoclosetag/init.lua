local M = {}

local VOID = {
	area = true,
	base = true,
	br = true,
	col = true,
	embed = true,
	hr = true,
	img = true,
	input = true,
	link = true,
	meta = true,
	param = true,
	source = true,
	track = true,
	wbr = true,
}

local ENABLED_FTS = {
	html = true,
	htmldjango = true,
	blade = true,
	ejs = true,
	javascriptreact = true,
	typescriptreact = true,
	vue = true,
	svelte = true,
}

local function get_node_text(node, bufnr)
	if not node then return nil end
	if vim.treesitter.get_node_text then
		return vim.treesitter.get_node_text(node, bufnr)
	else
		local srow, scol, erow, ecol = node:range()
		local lines = vim.api.nvim_buf_get_text(bufnr, srow, scol, erow, ecol, {})
		return table.concat(lines, "\n")
	end
end

local function find_open_node(bufnr, opts)
	opts = opts or {}
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1

	-- Force parser to be fresh
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
	if ok and parser then pcall(parser.parse, parser) end

	-- If we *just* typed '>', nudge left. If manual, peek around the cursor.
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
	local col0 = col
	if vim.v.char == ">" then
		col0 = math.max(0, col - 1)
	else
		local here = line:sub(col + 1, col + 1) -- char under cursor (1-based)
		local prev = (col > 0) and line:sub(col, col) or ""
		if here == ">" then
			col0 = math.max(0, col - 1) -- caret is on '>'
		elseif prev == ">" then
			col0 = math.max(0, col - 1) -- caret is just after '>'
		end
	end

	local node
	if vim.treesitter.get_node then
		node = select(2, pcall(vim.treesitter.get_node, { bufnr = bufnr, pos = { row, col0 } }))
	end
	if not node and vim.treesitter.get_node_at_pos then
		node = vim.treesitter.get_node_at_pos(bufnr, row, col0, {})
	end
	-- walk up to find an opening tag
	local up = 8
	while node and up > 0 do
		local t = node:type()
		if t == "start_tag" or t == "jsx_opening_element" or t == "jsx_opening_fragment" then
			return node
		end
		if t == "self_closing_tag" or t == "jsx_self_closing_element" then
			return nil
		end
		node = node:parent()
		up = up - 1
	end
	return nil
end

local function opening_tag_name(open_node, bufnr)
	if not open_node then return nil end
	local t = open_node:type()

	-- html
	if t == "start_tag" then
		for child in open_node:iter_children() do
			if child:type() == "tag_name" then
				return get_node_text(child, bufnr)
			end
		end
		return nil
	end

	-- jsx fragment <>...</>
	if t == "jsx_opening_fragment" then
		return "<>" -- sentinel meaning “fragment”
	end

	-- jsx/tsx
	if t == "jsx_opening_element" then
		for child in open_node:iter_children() do
			local ct = child:type()
			if ct == "identifier" or ct == "jsx_identifier"
				or ct == "nested_identifier" or ct == "jsx_member_expression"
				or ct == "member_expression" or ct == "namespaced_name" then
				return get_node_text(child, bufnr)
			end
		end
	end

	return nil
end

local function enabled(bufnr)
	return ENABLED_FTS[vim.bo[bufnr].filetype] == true
end

local function insert_after_cursor(bufnr, text)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
	local maxcol = #line -- 0-based API uses [start_col, end_col) half-open range
	local start_col = math.min(col, maxcol)
	vim.api.nvim_buf_set_text(bufnr, row, start_col, row, start_col, { text })
end

function M.try_complete(bufnr)
	if not enabled(bufnr) then return end
	if vim.v.char ~= ">" then return end

	local open_node = find_open_node(bufnr)
	if not open_node then return end

	local name = opening_tag_name(open_node, bufnr)
	if not name then return end

	-- skip html voids (case-insensitive)
	if name ~= "<>" and VOID[string.lower(name)] then return end

	vim.schedule(function()
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
		local left = line:sub(1, col)
		if left:match("/%s*>%s*$") then return end -- user typed '/>'

		local closing = (name == "<>") and "</>" or ("</" .. name .. ">")
		insert_after_cursor(bufnr, closing) -- <-- no +1
	end)
end

function M.manual_close(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if not enabled(bufnr) then return end

	local open_node = find_open_node(bufnr, { manual = true })
	if not open_node then return end

	local name = opening_tag_name(open_node, bufnr)
	if not name then return end
	if name ~= "<>" and VOID[string.lower(name)] then return end

	-- If we are exactly before '>', avoid inserting inside the tag text
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
	local here = line:sub(col + 1, col + 1)
	if here == ">" then
		-- hop after '>' so insertion goes between tags
		vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	end

	-- if it's already self-closing (`/>`), bail
	local left = line:sub(1, col)
	if left:match("/%s*>%s*$") then return end

	vim.schedule(function()
		local closing = (name == "<>") and "</>" or ("</" .. name .. ">")
		insert_after_cursor(bufnr, closing)
	end)
end

function M.setup(opts)
	opts = opts or {}
	if opts.filetypes then
		ENABLED_FTS = {}
		for _, ft in ipairs(opts.filetypes) do ENABLED_FTS[ft] = true end
	end

	if opts.autocomplete then
		local grp = vim.api.nvim_create_augroup("AutoCloseTag", { clear = true })
		vim.api.nvim_create_autocmd("InsertCharPre", {
			group = grp,
			callback = function(args)
				M.try_complete(args.buf)
			end,
		})
	end

	vim.keymap.set("i", "<C-/>", function() M.manual_close() end, { desc = "Insert closing tag for current element" })
end

return M
