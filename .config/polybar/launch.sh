#!/bin/sh

# Terminate already running bar instances
killall -q polybar
kill $(pgrep --full "bash $HOME/.bin/pavolume.sh")

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Load polybar for each monitor
for m in $MONITORS; do
	MONITOR="$m" polybar --reload mainbar-bspwm -c ~/.config/polybar/config &
done
