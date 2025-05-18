# -*- coding: utf-8 -*-
# LLM generated weechat plugin that supposedly applies a colorscheme inspired by
# the doom-one kitty theme here:
# https://github.com/NTBBloodbath/doom-one.nvim/blob/main/extras/kitty-light.conf

import weechat

SCRIPT_NAME = "theme"
SCRIPT_AUTHOR = "chatgpt"
SCRIPT_VERSION = "1.0"
SCRIPT_LICENSE = "MIT"
SCRIPT_DESC = "Switch between dark and light themes"


def apply_theme(theme):
    weechat.command("", "/color reset")

    if theme == "dark":
        aliases = {
            0: "#282c34",
            1: "#ff6c6b",
            2: "#98be65",
            3: "#ecbe7b",
            4: "#51afef",
            5: "#a9a1e1",
            6: "#46d9ff",
            7: "#bbc2cf",
            8: "#3f444a",
        }
    elif theme == "light":
        aliases = {
            0: "#fafafa",
            1: "#e45649",
            2: "#50a14f",
            3: "#986801",
            4: "#4078f2",
            5: "#b751b6",
            6: "#0184bc",
            7: "#383a42",
            8: "#9ca0a4",
        }
    else:
        weechat.prnt("", "Usage: /theme dark|light")
        return

    for i, color in aliases.items():
        weechat.command("", f"/color alias {i} {color}")

    # Apply some general colors using the aliases
    cmds = [
        "/set weechat.color.chat 7",
        "/set weechat.color.chat_time 8",
        "/set weechat.color.chat_prefix_suffix 4",
        "/set weechat.color.chat_prefix_buffer 4",
        "/set weechat.color.chat_nick 5",
        "/set weechat.color.chat_nick_self 2",
        "/set weechat.color.chat_nick_other 5",
        "/set weechat.color.chat_nick_offline 8",
        "/set weechat.color.chat_host 8",
        "/set weechat.color.chat_highlight 6",
        "/set weechat.color.chat_highlight_bg 1",
        "/set weechat.color.chat_channel 4",
        "/set weechat.color.chat_value 3",
        "/set weechat.color.chat_read_marker 1",
        "/set weechat.color.status_name 7",
        "/set weechat.color.status_time 8",
        "/set weechat.color.status_data_msg 1",
        "/set weechat.color.bar_more 6",
        "/set weechat.bar.status.color_fg 7",
        "/set weechat.bar.status.color_bg 0",
        "/set weechat.bar.input.color_fg 7",
        "/set weechat.bar.input.color_bg 0",
        "/set weechat.bar.title.color_fg 7",
        "/set weechat.bar.title.color_bg 8",
        "/set weechat.color.separator 8",
    ]

    for cmd in cmds:
        weechat.command("", cmd)

    weechat.prnt("", f"WeeChat theme switched to: {theme}")


def theme_cmd_cb(data, buffer, args):
    apply_theme(args.strip())
    return weechat.WEECHAT_RC_OK


# Register script
if weechat.register(
    SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, "", ""
):
    weechat.hook_command(
        "theme",
        "Switch between dark and light themes",
        "dark | light",
        "Choose a theme:\n"
        "  dark:  Kitty-inspired dark theme\n"
        "  light: Kitty-inspired light theme",
        "dark || light",
        "theme_cmd_cb",
        "",
    )
