#!/bin/sh

# Start optimus manager
/usr/bin/prime-offload &

# Hide cursor after one second
unclutter --timeout 1 &

# Turn off key repeat
xset r r off &

# Map capslock to esc & ctrl
setxkbmap -option ctrl:nocaps &
xcape -e 'Control_L=Escape' &

# cursor fix
xsetroot -cursor_name left_ptr &

[ -f "$HOME/.Xresources" ] && xrdb -merge -I$HOME ~/.Xresources

# Keyring setup
eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
export SSH_AUTH_SOCK

# Check for monitors
NUMMONS="$(xrandr --query | rg " connected" | cut -d" " -f1 | wc -l)"
export NUMMONS

if [ "$NUMMONS" -eq 2 ]; then
	/home/ml/.bin/dm-do
else
	/home/ml/.bin/sm-do
fi

# start bspwm
bspwm
