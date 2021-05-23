def blood(c, options={}):
    palette = {
        "background": "#181819",
        "background-alt": "#181819",
        "background-attention": "#080808",
        "border": "#181819",
        "current-line": "#373c40",
        "selection": "#8DA54E",
        "foreground": "#b2b2b2",
        "foreground-alt": "#b2b2b2",
        "foreground-attention": "#fafafa",
        "comment": "#984673",
        "cyan": "#6CCEB8",
        "green": "#8DA54E",
        "orange": "#617E9C",
        "pink": "#CAD4C8",
        "purple": "#984673",
        "red": "#D1616B",
        "yellow": "#B0A280",
    }

    spacing = options.get("spacing", {"vertical": 5, "horizontal": 5})

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
    c.colors.completion.odd.bg = palette["background-alt"]
    c.colors.completion.fg = palette["foreground"]
    c.colors.completion.item.selected.bg = palette["selection"]
    c.colors.completion.item.selected.border.bottom = palette["selection"]
    c.colors.completion.item.selected.border.top = palette["selection"]
    c.colors.completion.item.selected.fg = palette["background"]
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
    c.hints.border = "1px solid " + palette["background-alt"]
    c.colors.hints.match.fg = palette["foreground-alt"]

    # Keyhints
    c.colors.keyhint.bg = palette["background"]
    c.colors.keyhint.fg = palette["purple"]
    c.colors.keyhint.suffix.fg = palette["selection"]

    # Messages
    c.colors.messages.error.bg = palette["background"]
    c.colors.messages.error.border = palette["background-alt"]
    c.colors.messages.error.fg = palette["red"]
    c.colors.messages.info.bg = palette["background"]
    c.colors.messages.info.border = palette["background-alt"]
    c.colors.messages.info.fg = palette["comment"]
    c.colors.messages.warning.bg = palette["background"]
    c.colors.messages.warning.border = palette["background-alt"]
    c.colors.messages.warning.fg = palette["red"]

    # Prompts
    c.colors.prompts.bg = palette["background"]
    c.colors.prompts.border = "1px solid " + palette["background-alt"]
    c.colors.prompts.fg = palette["cyan"]
    c.colors.prompts.selected.bg = palette["selection"]

    # Statusbar
    c.colors.statusbar.caret.bg = palette["background"]
    c.colors.statusbar.caret.fg = palette["orange"]
    c.colors.statusbar.caret.selection.bg = palette["background"]
    c.colors.statusbar.caret.selection.fg = palette["orange"]
    c.colors.statusbar.command.bg = palette["background"]
    c.colors.statusbar.command.fg = palette["pink"]
    c.colors.statusbar.command.private.bg = palette["background"]
    c.colors.statusbar.command.private.fg = palette["foreground-alt"]
    c.colors.statusbar.insert.bg = palette["background-attention"]
    c.colors.statusbar.insert.fg = palette["foreground-attention"]
    c.colors.statusbar.normal.bg = palette["background"]
    c.colors.statusbar.normal.fg = palette["foreground"]
    c.colors.statusbar.passthrough.bg = palette["background"]
    c.colors.statusbar.passthrough.fg = palette["orange"]
    c.colors.statusbar.private.bg = palette["background-alt"]
    c.colors.statusbar.private.fg = palette["foreground-alt"]
    c.colors.statusbar.progress.bg = palette["background"]
    c.colors.statusbar.url.error.fg = palette["red"]
    c.colors.statusbar.url.fg = palette["foreground"]
    c.colors.statusbar.url.hover.fg = palette["cyan"]
    c.colors.statusbar.url.success.http.fg = palette["green"]
    c.colors.statusbar.url.success.https.fg = palette["green"]
    c.colors.statusbar.url.warn.fg = palette["yellow"]
    c.statusbar.padding = padding

    # Background color of the tab bar.
    c.colors.tabs.bar.bg = palette["selection"]
    c.colors.tabs.even.bg = palette["background"]
    c.colors.tabs.even.fg = palette["foreground"]
    c.colors.tabs.indicator.error = palette["red"]
    c.colors.tabs.indicator.start = palette["orange"]
    c.colors.tabs.indicator.stop = palette["green"]
    c.colors.tabs.indicator.system = "none"
    c.colors.tabs.odd.bg = palette["background"]
    c.colors.tabs.odd.fg = palette["foreground"]
    c.colors.tabs.selected.even.bg = palette["selection"]
    c.colors.tabs.selected.even.fg = palette["background"]
    c.colors.tabs.selected.odd.bg = palette["selection"]
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
    c.tabs.indicator.width = 1
    c.tabs.favicons.scale = 1
