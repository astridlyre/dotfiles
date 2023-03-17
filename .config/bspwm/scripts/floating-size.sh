#!/bin/bash

# Default floating window sizes:
# Small: 480x270
# Medium: 640x360
# Large: 960x540

function resize_to_dimensions() {
	local x
	local y

	x="$1"
	y="$2"

	read < <(bspc query -T -n focused.window | jq -r '"\(.id) \(.client.state)"') -r node node_state

	if [ "$node_state" = "floating" ]; then
		xdo resize -t "$node" -w "$x" -h "$y"
	fi
}

case "$1" in
"small" | "s")
	resize_to_dimensions 480 270
	;;
"medium" | "m")
	resize_to_dimensions 640 360
	;;
"large" | "l")
	resize_to_dimensions 960 540
	;;
*) ;;
esac
