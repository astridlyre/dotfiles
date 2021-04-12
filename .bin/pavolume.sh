#!/usr/bin/env bash

# finds the active sink for pulse audio and increments the volume. useful when you have multiple audio outputs and have a key bound to vol-up and down

inc='2'
capvol='no'
maxvol='200'
autosync='yes'

# Muted status
# yes: muted
# no : not muted
curStatus="no"
active_sink=""
limit=$((100 - inc))
maxlimit=$((maxvol - inc))

reloadSink() {
	active_sink="$(pactl list sinks | grep -E -o 'Name: .*')"
	active_sink="${active_sink//Name: /}"
}

is_muted() {
  [ "$curStatus" = 'yes' ] && return 0
  return 1
}

function volUp {

	getCurVol

	if [ "$capvol" = 'yes' ]; then
		if [ "$curVol" -le 100 ] && [ "$curVol" -ge "$limit" ]; then
			pactl set-sink-volume "$active_sink" -- 100%
		elif [ "$curVol" -lt "$limit" ]; then
			pactl set-sink-volume "$active_sink" -- "+$inc%"
		fi
	elif [ "$curVol" -le "$maxvol" ] && [ "$curVol" -ge "$maxlimit" ]; then
		pactl set-sink-volume "$active_sink" "$maxvol%"
	elif [ "$curVol" -lt "$maxlimit" ]; then
		pactl set-sink-volume "$active_sink" "+$inc%"
	fi

	getCurVol

	if [ ${autosync} = 'yes' ]; then
		volSync
	fi
}

function volDown {

	getCurVol
	pactl set-sink-volume "$active_sink" "-$inc%"

	if [ ${autosync} = 'yes' ]; then
		volSync
	fi

}

function getSinkInputs {
	input_array=$(pactl list sink-inputs | grep -B 4 "sink: $1 " | awk '/index:/{print $2}')
}

function volSync {
	getSinkInputs "$active_sink"
	getCurVol

	for each in $input_array; do
		pactl set-sink-input-volume "$each" "$curVol%"
	done
}

function getCurVol {
	curVol=$(pactl list sinks | grep -E '^\s*Volume' | grep -E -o '[0-9]+%' | sed 1d)
	curVol=${curVol%\%}
}

function volMute {
	case "$1" in
	mute)
		pactl set-sink-mute "$active_sink" 1
		curVol=0
		;;
	unmute)
		pactl set-sink-mute "$active_sink" 0
		getCurVol
		;;
	esac

}

function volMuteStatus {
	curStatus=$(pactl list sinks | grep -E -o 'Mute: (yes|no)')
	curStatus=${curStatus//Mute: /}
}

# Prints output for bar
# Listens for events for fast update speed
function listen {
	firstrun=0

	pactl subscribe 2>/dev/null | {
		while true; do
			{
				# If this is the first time just continue
				# and print the current state
				# Otherwise wait for events
				# This is to prevent the module being empty until
				# an event occurs
				if [ $firstrun -eq 0 ]; then
					firstrun=1
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

function output() {
	reloadSink
	getCurVol
	volMuteStatus
	if is_muted; then
		echo " $curVol%"
	else
		echo " $curVol%"
	fi
} #}}}

reloadSink
case "$1" in
--up)
	volUp
	;;
--down)
	volDown
	;;
--togmute)
	volMuteStatus
	if is_muted; then
		volMute unmute
	else
		volMute mute
	fi
	;;
--mute)
	volMute mute
	;;
--unmute)
	volMute unmute
	;;
--sync)
	volSync
	;;
--listen)
	# Listen for changes and immediately create new output for the bar
	# This is faster than having the script on an interval
	listen
	;;
*)
	# By default print output for bar
	output
	;;
esac

