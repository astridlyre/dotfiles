#!/bin/bash

# Move a floating window to one of the screen corners

declare -i w
declare -i h

read < <(bspc query -T -n focused.window | jq -r '"\(.id) \(.client.state)"') -r node node_state

if [[ $node_state != "floating" ]]; then
	notify-send -a test "Window is not floating ${node_state}"
	exit
fi

h=$(xwininfo -id "$node" | rg -i "Height" | cut -d: -f2)
w=$(xwininfo -id "$node" | rg -i "Width" | head -n1 | cut -d: -f2)

case "$1" in
top-left)
	xdo move -x 0 -y 0 "$node"
	;;
top-right)
	xdo move -x $((1920 - w)) -y 0 "$node"
	;;
bottom-left)
	xdo move -x 0 -y $((1080 - h)) "$node"
	;;
bottom-right)
	xdo move -x $((1920 - w)) -y $((1080 - h)) "$node"
	;;
*) ;;
esac
