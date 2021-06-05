-- Lualine
local function theme()
    local colors = {
        black = '#1b1b20',
        white = '#b4b4b9',
        red = '#ff3600',
        green = '#718e3f',
        blue = '#635196',
        yellow = '#ffc552',
        gray = '#57575e',
        darkgray = '#36363a',
        lightgray = '#dfdfe5',
        inactivegray = '#28282d'
    }
    return {
        normal = {
            a = {bg = colors.yellow, fg = colors.black, gui = 'bold'},
            b = {bg = colors.gray, fg = colors.lightgray},
            c = {bg = colors.darkgray, fg = colors.lightgray}
        },
        insert = {
            a = {bg = colors.red, fg = colors.black, gui = 'bold'},
            b = {bg = colors.gray, fg = colors.lightgray},
            c = {bg = colors.darkgray, fg = colors.lightgray}
        },
        visual = {
            a = {bg = colors.green, fg = colors.black, gui = 'bold'},
            b = {bg = colors.gray, fg = colors.lightgray},
            c = {bg = colors.darkgray, fg = colors.lightgray}
        },
        replace = {
            a = {bg = colors.blue, fg = colors.black, gui = 'bold'},
            b = {bg = colors.gray, fg = colors.lightgray},
            c = {bg = colors.darkgray, fg = colors.lightgray}
        },
        command = {
            a = {bg = colors.green, fg = colors.black, gui = 'bold'},
            b = {bg = colors.gray, fg = colors.lightgray},
            c = {bg = colors.darkgray, fg = colors.lightgray}
        },
        inactive = {
            a = {bg = colors.gray, fg = colors.gray, gui = 'bold'},
            b = {bg = colors.inactivegray, fg = colors.gray},
            c = {bg = colors.inactivegray, fg = colors.gray}
        }
    }
end
require('lualine').setup {
    options = {
        theme = theme(),
        section_separators = '',
        component_separators = '',
        padding = 1
    }
}
