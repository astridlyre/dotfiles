local function add_luarocks_paths()
	local home_dir = os.getenv("HOME")
	local luarocks_path = string.format(
		"%s/.luarocks-luajit/share/lua/5.1/?.lua;%s/.luarocks-luajit/share/lua/5.1/?/init.lua", home_dir, home_dir)
	local luarocks_cpath = string.format("%s/.luarocks-luajit/lib/lua/5.1/?.so", home_dir)
	package.path = package.path .. ";" .. luarocks_path
	package.cpath = package.cpath .. ";" .. luarocks_cpath
end

return { add_luarocks_paths = add_luarocks_paths }
