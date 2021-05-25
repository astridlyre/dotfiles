#!/bin/sh

run() {
	if ! pgrep "$1"; then
		"$@" &
	fi
}

# Launch polybar
"$HOME/.config/polybar/launch.sh" &

# Start hotkey daemon
run sxhkd -c ~/.config/bspwm/sxhkd/sxhkdrc

# Start unclutter to hide cursor
run unclutter --timeout 1

# Applets
run numlockx on
# blueberry-tray &

# Compositor
run picom --experimental-backends --config "$HOME/.config/bspwm/picom.conf"

#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
#/usr/lib/xfce4/notifyd/xfce4-notifyd &

# Background image
run feh --bg-fill "$HOME/Pictures/Wallpapers/fishbg.jpg"
