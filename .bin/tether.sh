#!/bin/bash
#
function main() {
	local cmd
	cmd="${1}"

	if [[ "${cmd}" == 'start' ]]; then
		sudo systemctl start usbmuxd.service
		sudo networkctl reload
	else
		sudo systemctl stop usbmuxd.service
		sudo networkctl reload
	fi
}

main "${@}"
