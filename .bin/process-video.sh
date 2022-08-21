#!/bin/bash

#  ___ _   _ _____ _    _   _ _____ _   _  ____ _____ ____
# |_ _| \ | |  ___| |  | | | | ____| \ | |/ ___| ____|  _ \
#  | ||  \| | |_  | |  | | | |  _| |  \| | |   |  _| | |_) |
#  | || |\  |  _| | |__| |_| | |___| |\  | |___| |___|  _ <
# |___|_| \_|_|   |_____\___/|_____|_| \_|\____|_____|_| \_\
#
# __     _____ ____  _____ ___
# \ \   / /_ _|  _ \| ____/ _ \
#  \ \ / / | || | | |  _|| | | |
#   \ V /  | || |_| | |__| |_| |
#    \_/  |___|____/|_____\___/
#

WIDTH=
HEIGHT=

SCALE_WIDTH=
SCALE_HEIGHT=

TARGET_WIDTH=320
TARGET_HEIGHT=320

ORIGINAL_FILE="$1"
OUTPUT_FILE="$2"
TMP_FILE=
SCALED_FILE=
CROPPED_FILE=

function is_mov() {
	local file_ext
	file_ext="${1##*.}"
	file_ext="${file_ext,,}"

	if [[ "${file_ext}" == "mov" ]]; then
		return 0
	fi

	return 1
}

function get_original_resolution() {
	local resolution
	resolution=$(ffprobe "${TMP_FILE}" 2>&1 | rg 'Stream' | rg -o '([\d]{2,}x[\d]{2,})')

	WIDTH=${resolution/x*/}
	HEIGHT=${resolution/*x/}

	echo "Detected width as ${WIDTH}px and height as ${HEIGHT}px"
}

function set_scale_dimensions() {
	if ((WIDTH < HEIGHT)); then
		SCALE_WIDTH=320
		SCALE_HEIGHT=-1
	else
		SCALE_WIDTH=-1
		SCALE_HEIGHT=320
	fi

	echo "Scaling to ${SCALE_WIDTH}:${SCALE_HEIGHT}"
}

function setup_working_file() {
	TMP_FILE=$(mktemp --suffix=.mov)

	if ! is_mov "${ORIGINAL_FILE}"; then
		ffmpeg -y -i "${ORIGINAL_FILE}" "${TMP_FILE}" &>/dev/null
	else
		cp "${ORIGINAL_FILE}" "${TMP_FILE}" &>/dev/null
	fi

	echo "Copied to working file: ${TMP_FILE}"
}

function scale_video() {
	SCALED_FILE=$(mktemp --suffix=.mov)

	while ! ffmpeg -y -i "${TMP_FILE}" -vf "scale=${SCALE_WIDTH}:${SCALE_HEIGHT}" "${SCALED_FILE}" &>/dev/null; do
		if ((SCALE_WIDTH == -1)); then
			((SCALE_HEIGHT += 2))
		else
			((SCALE_WIDTH += 2))
		fi
		echo "Scale failed, attemping to scale with ${SCALE_WIDTH}:${SCALE_HEIGHT}"
	done

	echo "Scaled to file: ${SCALED_FILE}"
}

function crop_video() {
	CROPPED_FILE=$(mktemp --suffix=.mov)

	if ! ffmpeg -y -i "${SCALED_FILE}" -vf "crop=${TARGET_WIDTH}:${TARGET_HEIGHT}" "${CROPPED_FILE}" &>/dev/null; then
		echo "Unable to crop file"
		exit 1
	fi

	echo "Cropped to file: ${CROPPED_FILE}"
}

function clean_up() {
	local final_file

	if [[ -z "${OUTPUT_FILE}" ]]; then
		final_file="${ORIGINAL_FILE%%.*}-cropped.mov"
	else
		final_file="${OUTPUT_FILE}"
	fi

	mv "${CROPPED_FILE}" "${final_file}"
	echo "Output file: ${final_file}"

	rm "${TMP_FILE}" "${SCALED_FILE}" "${CROPPED_FILE}" &>/dev/null
	echo "Removed tmp files"

	echo "All done!"
}

function usage() {
	local filename

	filename=$(basename "$0")

	cat <<EOF
Usage:
	${filename} [INPUT FILE] [OUTPUT FILE]
EOF
}

function main() {
	setup_working_file
	get_original_resolution
	set_scale_dimensions
	scale_video
	crop_video
	clean_up
}

if [[ -z "${ORIGINAL_FILE}" ]]; then
	usage
	exit 1
fi

main
