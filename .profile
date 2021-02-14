#!/bin/sh

# Keyring setup
if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

# Hide cursor after one second
unclutter --timeout 1 &

# Turn off key repeat
xset r r off

# Map capslock to esc & ctrl
setxkbmap -option ctrl:nocaps
xcape -e 'Control_L=Escape' &

# cursor fix
xsetroot -cursor_name left_ptr
