#!/bin/sh

# Start optimus manager
/usr/bin/prime-offload &

# Turn off key repeat
xset r r off &

# Set kbd color
kbd_color -d &

# Map capslock to esc & ctrl
setxkbmap -option ctrl:nocaps &

if ! pgrep xcape; then
  xcape -e 'Control_L=Escape'
fi

# cursor fix
xsetroot -cursor_name left_ptr &

[ -f "$HOME/.Xresources" ] && xrdb -merge -I$HOME ~/.Xresources

# Keyring setup
eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
export SSH_AUTH_SOCK

export QT_AUTO_SCREEN_SCALE_FACTOR=1

# Check for monitors
NUMMONS="$(xrandr --query | rg " connected" | cut -d" " -f1 | wc -l)"
if [ "$NUMMONS" -eq 2 ]; then
	/home/ml/.bin/dm-do
else
	/home/ml/.bin/sm-do
fi

# start bspwm
bspwm
