#!/bin/bash

FIRST_RUN=0
MAX_BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/max_brightness)
ACTUAL_BRIGHTNESS=

output() {
	local value

	ACTUAL_BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/actual_brightness)

	value=$(bc <<<"scale=2;${ACTUAL_BRIGHTNESS} / ${MAX_BRIGHTNESS} * 100")

	echo "${value%%.*}%"
}

listen() {
	udevadm monitor --udev 2>/dev/null | {
		while true; do
			{
				if ((FIRST_RUN == 0)); then
					FIRST_RUN=1
				else
					read -r event || break
					if ! echo "$event" | grep -e "intel_backlight"; then
						continue
					fi
				fi
			} &>/dev/null
			output
		done
	}
}

case "$1" in
--listen)
	listen
	;;
*)
	output
	;;
esac
