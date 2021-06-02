#!/bin/sh

# Terminate already running bar instances
killall -q polybar
killall pactl
kill $(pgrep --full "bash $HOME/.bin/pavolume.sh")

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Load polybar for each monitor
if [ "$MONITORS" -eq 2 ]; then
	MONITOR="HDMI-0" polybar --reload mainbar-bspwm -c ~/.config/polybar/config &
	MONITOR="eDP-1-1" polybar --reload mainbar-bspwm-extra -c ~/.config/polybar/config &
else
	MONITOR="eDP-1-1" polybar --reload mainbar-bspwm -c ~/.config/polybar/config &
fi
