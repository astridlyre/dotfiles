#!/usr/bin/env bash
#
# pavolume.sh - Easy to use bar script to adjust volume
#
# Usage: pavolume [--up, --down, --togmute, --mute, --unmute, --listen]
#

declare -i INC=2       # Increment step
declare -i LIMIT=100   # Volume Limit
declare -i FIRST_RUN=0 # First time running the script?

ICON_COLOR="#ff3600" # Icon color
TEXT_COLOR="#b4b4b9" # Text color
ACTIVE_SINK=""       # Active Sink
CURRENT_VOLUME=""    # Current Volume

# Returns usage information
usage() {
	printf '\n\e[1;32m%s\e[0m - An easy to use bar script to adjust volume\n' "$(basename "$0")"
	printf '\n\e[0;35mOptions:\t\e[1;39m--up\e[0m\t\t(increase volume)'
	printf '\n\t\t\e[1;39m--down\e[0m\t\t(decrease volume)'
	printf '\n\t\t\e[1;39m--togmute\e[0m\t(toggle muted)'
	printf '\n\t\t\e[1;39m--mute\e[0m\t\t(mute volume)'
	printf '\n\t\t\e[1;39m--unmute\e[0m\t(unmute volume)'
	printf '\n\t\t\e[1;39m--listen\e[0m\t(listen for events)'
	printf '\n\t\t\e[1;39m--help\e[0m\t\t(print this message)'
	printf '\n\nBy default, this script prints output for a bar like polybar\nor lemonbar.\n'
	exit 0
}

# Returns name of default sink
get_active_sink() {
	# Read Default Sink
	while read -r line; do
		[[ $line =~ ^Default\ Sink:\  ]] && ACTIVE_SINK="${line//Default Sink: /}" && break
	done <<<"$(pactl info)"
}

# Returns 0 if muted and 1 if not muted
is_muted() {
	local state
	state=$(pactl list sinks | grep -E -o 'Mute: (yes|no)')
	[[ ${state//Mute: /} =~ 'yes' ]] && return 0
	return 1
}

# Returns the current volume of the ACTIVE_SINK
refresh_volume() {
	while read -r line; do
		if [[ $line =~ ^\s*Volume: ]]; then
			CURRENT_VOLUME="${line#*/ *[^0-9]}"
			CURRENT_VOLUME="${CURRENT_VOLUME%%\%*}"
			break
		fi
	done <<<"$(pactl list sinks | grep -A 8 -m 1 -E "$ACTIVE_SINK")"
}

# increases the volume by INC
increase_volume() {
	refresh_volume # Refresh volume level

	# Perform upper bounds checking
	if ((CURRENT_VOLUME < LIMIT && (CURRENT_VOLUME + INC) > LIMIT)); then
		pactl set-sink-volume "$ACTIVE_SINK" 100%
	elif ((CURRENT_VOLUME < LIMIT)); then
		pactl set-sink-volume "$ACTIVE_SINK" "+$INC%"
	fi

	refresh_volume # Refresh volume level
}

# decreases the volume by INC
decrease_volume() {
	pactl set-sink-volume "$ACTIVE_SINK" "-$INC%" # Set new volume
	refresh_volume                                # Refresh volume level
}

# mutes the sink volume
mute_volume() {
	pactl set-sink-mute "$ACTIVE_SINK" 1
	CURRENT_VOLUME=0
	return 0
}

# unmutes the sink volume
unmute_volume() {
	pactl set-sink-mute "$ACTIVE_SINK" 0
	refresh_volume
	return 0
}

# Listens for events for fast update speed
listen() {

	pactl subscribe 2>/dev/null | {
		while true; do
			{
				# If this is the first time just continue
				# and print the current state
				# Otherwise wait for events
				# This is to prevent the module being empty until
				# an event occurs
				if ((FIRST_RUN == 0)); then
					FIRST_RUN=1
				else
					read -r event || break
					if ! echo "$event" | grep -e "on card" -e "on sink"; then
						# Avoid double events
						continue
					fi
				fi
			} &>/dev/null
			output
		done
	}
}

# Prints output for bar
output() {
	get_active_sink # Gets active sink
	refresh_volume  # Refresh volume
	if is_muted; then
		echo "%{F${ICON_COLOR}}  %{F${TEXT_COLOR}}$CURRENT_VOLUME%%{F-}"
	else
		echo "%{F${ICON_COLOR}}  %{F${TEXT_COLOR}}$CURRENT_VOLUME%%{F-}"
	fi
}

# Script Control Flow
get_active_sink
case "$1" in
	--up)
		increase_volume
		;;
	--down)
		decrease_volume
		;;
	--togmute)
		if is_muted; then
			unmute_volume
		else
			mute_volume
		fi
		;;
	--mute)
		mute_volume
		;;
	--unmute)
		unmute_volume
		;;
	--listen)
		# Listen for changes and immediately create new output for the bar
		listen
		;;
	--help)
		usage
		;;
	*)
		# By default print output for bar
		output
		;;
esac
