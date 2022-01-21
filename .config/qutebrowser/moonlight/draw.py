def blood(c, options={}):
    palette = {
        "background": "#1e1d2f",
        "background-alt": "#161320",
        "background-attention": "#f5c2e7",
        "border": "#302d41",
        "selection-background": "#abe9b3",
        "selection-foreground": "#161320",
        "foreground": "#d9e0ee",
        "foreground-alt": "#f5e0dc",
        "foreground-attention": "#161320",
        "grey": "#6e6c7e",
        "comment": "#f5c2e7",
        "pink": "#f5c2e7",
        "green": "#abe9b3",
        "orange": "#f8bd96",
        "purple": "#ddb6f2",
        "red": "#f28fad",
        "yellow": "#fae3b0",
    }

    spacing = options.get("spacing", {"vertical": 0, "horizontal": 0})

    padding = options.get(
        "padding",
        {
            "top": spacing["vertical"],
            "right": spacing["horizontal"],
            "bottom": spacing["vertical"],
            "left": spacing["horizontal"],
        },
    )

    # Completion
    c.colors.completion.category.bg = palette["background"]
    c.colors.completion.category.border.bottom = palette["border"]
    c.colors.completion.category.border.top = palette["border"]
    c.colors.completion.category.fg = palette["foreground"]
    c.colors.completion.even.bg = palette["background"]
    c.colors.completion.odd.bg = palette["background"]
    c.colors.completion.fg = palette["foreground"]
    c.colors.completion.item.selected.bg = palette["selection-background"]
    c.colors.completion.item.selected.border.bottom = palette["selection-background"]
    c.colors.completion.item.selected.border.top = palette["selection-background"]
    c.colors.completion.item.selected.fg = palette["selection-foreground"]
    c.colors.completion.item.selected.match.fg = palette["foreground-attention"]
    c.colors.completion.match.fg = palette["comment"]
    c.colors.completion.scrollbar.bg = palette["background"]
    c.colors.completion.scrollbar.fg = palette["foreground"]

    # Background color for the download bar.
    c.colors.downloads.bar.bg = palette["background"]
    c.colors.downloads.error.bg = palette["background"]
    c.colors.downloads.error.fg = palette["red"]
    c.colors.downloads.start.bg = palette["purple"]
    c.colors.downloads.start.fg = palette["background"]
    c.colors.downloads.stop.bg = palette["background"]
    c.colors.downloads.stop.fg = palette["foreground"]
    c.colors.downloads.system.bg = "none"
    c.colors.downloads.system.fg = "none"

    # Hints
    c.colors.hints.bg = palette["background-attention"]
    c.colors.hints.fg = palette["foreground-attention"]
    c.hints.border = "1px solid " + palette["background-attention"]
    c.colors.hints.match.fg = palette["foreground-attention"]

    # Context Menu
    c.colors.contextmenu.menu.bg = palette["background"]
    c.colors.contextmenu.menu.fg = palette["foreground"]
    c.colors.contextmenu.selected.bg = palette["selection-background"]
    c.colors.contextmenu.selected.fg = palette["selection-foreground"]
    c.colors.contextmenu.disabled.bg = palette["background"]
    c.colors.contextmenu.disabled.fg = palette["grey"]

    # Keyhints
    c.colors.keyhint.bg = palette["background-alt"]
    c.colors.keyhint.fg = palette["foreground-alt"]
    c.colors.keyhint.suffix.fg = palette["selection-background"]

    # Messages
    c.colors.messages.error.bg = palette["background-alt"]
    c.colors.messages.error.border = palette["red"]
    c.colors.messages.error.fg = palette["red"]
    c.colors.messages.info.bg = palette["background-alt"]
    c.colors.messages.info.border = palette["border"]
    c.colors.messages.info.fg = palette["foreground"]
    c.colors.messages.warning.bg = palette["background-alt"]
    c.colors.messages.warning.border = palette["orange"]
    c.colors.messages.warning.fg = palette["orange"]

    # Prompts
    c.colors.prompts.bg = palette["background-alt"]
    c.colors.prompts.border = "1px solid " + palette["selection-background"]
    c.colors.prompts.fg = palette["foreground-alt"]
    c.colors.prompts.selected.bg = palette["selection-background"]

    # Statusbar
    c.colors.statusbar.caret.bg = palette["background"]
    c.colors.statusbar.caret.fg = palette["foreground"]
    c.colors.statusbar.caret.selection.bg = palette["selection-background"]
    c.colors.statusbar.caret.selection.fg = palette["selection-foreground"]
    c.colors.statusbar.command.bg = palette["green"]
    c.colors.statusbar.command.fg = palette["foreground-attention"]
    c.colors.statusbar.command.private.bg = palette["green"]
    c.colors.statusbar.command.private.fg = palette["foreground-attention"]
    c.colors.statusbar.insert.bg = palette["red"]
    c.colors.statusbar.insert.fg = palette["foreground-attention"]
    c.colors.statusbar.normal.bg = palette["pink"]
    c.colors.statusbar.normal.fg = palette["background"]
    c.colors.statusbar.passthrough.bg = palette["orange"]
    c.colors.statusbar.passthrough.fg = palette["foreground-attention"]
    c.colors.statusbar.private.bg = palette["pink"]
    c.colors.statusbar.private.fg = palette["background"]
    c.colors.statusbar.progress.bg = palette["background"]
    c.colors.statusbar.url.error.fg = palette["red"]
    c.colors.statusbar.url.fg = palette["foreground-attention"]
    c.colors.statusbar.url.hover.fg = palette["foreground-attention"]
    c.colors.statusbar.url.success.http.fg = palette["foreground-attention"]
    c.colors.statusbar.url.success.https.fg = palette["foreground-attention"]
    c.colors.statusbar.url.warn.fg = palette["foreground-attention"]
    c.statusbar.padding = padding

    # Background color of the tab bar.
    c.colors.tabs.bar.bg = palette["pink"]
    c.colors.tabs.even.bg = palette["background"]
    c.colors.tabs.even.fg = palette["foreground"]
    c.colors.tabs.indicator.error = palette["red"]
    c.colors.tabs.indicator.start = palette["orange"]
    c.colors.tabs.indicator.stop = palette["green"]
    c.colors.tabs.indicator.system = "none"
    c.colors.tabs.odd.bg = palette["background"]
    c.colors.tabs.odd.fg = palette["foreground"]
    c.colors.tabs.selected.even.bg = palette["pink"]
    c.colors.tabs.selected.even.fg = palette["background"]
    c.colors.tabs.selected.odd.bg = palette["pink"]
    c.colors.tabs.selected.odd.fg = palette["background"]
    c.colors.tabs.pinned.even.fg = palette["purple"]
    c.colors.tabs.pinned.even.bg = palette["background"]
    c.colors.tabs.pinned.odd.fg = palette["purple"]
    c.colors.tabs.pinned.odd.bg = palette["background"]
    c.colors.tabs.pinned.selected.even.fg = palette["background"]
    c.colors.tabs.pinned.selected.even.bg = palette["purple"]
    c.colors.tabs.pinned.selected.odd.fg = palette["background"]
    c.colors.tabs.pinned.selected.odd.bg = palette["purple"]

    # Tab padding
    c.tabs.padding = padding
    c.tabs.indicator.width = 0
    c.tabs.favicons.scale = 0
