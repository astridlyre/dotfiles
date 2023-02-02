#! /bin/bash
#

declare -i FIRST_RUN=0

ICON_COLOR="#A98FD2" # Icon color
TEXT_COLOR="#ddd8bb" # Text color

listen() {
	docker system events 2>/dev/null | {
		while true; do
			{
				# If this is the first time, get the number of running
				# containers
				if ((FIRST_RUN == 0)); then
					FIRST_RUN=1
				else
					read -r event || break
					if ! echo "${event}" | grep -o -e "container start" -e "container stop" -e "container destroy"; then
						# Avoid double events
						continue
					fi
				fi
			} &>/dev/null
			output
		done
	}
}

output() {
	echo "%{F${ICON_COLOR}}  %{F${TEXT_COLOR}}$(docker ps -aq | wc -l)%{F-}"
}

case "$1" in
--listen)
	listen
	;;
*)
	output
	;;
esac
