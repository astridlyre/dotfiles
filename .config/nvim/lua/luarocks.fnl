(fn add-luarocks-paths []
  (let [home-dir (os.getenv :HOME)
        luarocks-path (string.format "%s/.luarocks-luajit/share/lua/5.1/?.lua;%s/.luarocks-luajit/share/lua/5.1/?/init.lua"
                                     home-dir home-dir)
        luarocks-cpath (string.format "%s/.luarocks-luajit/lib/lua/5.1/?.so"
                                      home-dir)]
    (set package.path (.. package.path ";" luarocks-path))
    (set package.cpath (.. package.cpath ";" luarocks-cpath))))

{: add-luarocks-paths}
