#!/bin/sh
/usr/bin/prime-offload &                                     # Start optimus manager
xset r r off &                                               # Turn off key repeat
setxkbmap -option ctrl:nocaps &                              # Map capslock to esc & ctrl
pgrep xcape >/dev/null 2>&1 || xcape -e 'Control_L=Escape' & # Map Ctrl to Escape
xsetroot -cursor_name left_ptr &                             # cursor fix
eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"

export SSH_AUTH_SOCK                 # Keyring setup
export QT_AUTO_SCREEN_SCALE_FACTOR=1 # Scaling fix for QT
export AWT_TOOLKIT=MToolkit          # Fixes for Java Apps
export _JAVA_AWT_WM_NONREPARENTING=1 # Fixes for ghidra

# Check for monitors
NUMMONS="$(xrandr --query | rg " connected" | cut -d" " -f1 | wc -l)"
if [ "$NUMMONS" -eq 2 ]; then
	"$HOME/.bin/dm-do"
else
	"$HOME/.bin/sm-do"
fi

# Merge Xresources
[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"

# Start bspwm
exec bspwm
