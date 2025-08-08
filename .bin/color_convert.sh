#!/bin/bash

# Convert a hex color (#RRGGBB or #RRGGBBAA) to an RGBA value
convert_hex_to_rgba() {
	local hex="${1#"#"}" # Remove '#' if present

	# Ensure valid input
	if [[ ! "$hex" =~ ^[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$ ]]; then
		echo "Invalid hex color format" >&2
		return 1
	fi

	# Append 'FF' if only 6 characters (assume full opacity)
	[[ ${#hex} -eq 6 ]] && hex="${hex}ff"

	# Convert hex to integer
	local hex_int=$((16#$hex))

	# Extract RGBA components
	local red=$(((hex_int >> 24) & 0xFF))
	local green=$(((hex_int >> 16) & 0xFF))
	local blue=$(((hex_int >> 8) & 0xFF))
	local alpha=$((hex_int & 0xFF))

	# Convert alpha to a decimal (0-1)
	alpha=$(printf "%.2f" "$(awk "BEGIN {print $alpha / 255}")")

	# Output as rgba
	echo "rgba($red, $green, $blue, $alpha)"
}

# Convert an RGBA color (r, g, b, a) to a hex value (#RRGGBBAA)
convert_rgba_to_hex() {
	local input="$1"

	# Match formats like rgb(255, 87, 51) or rgba(255, 87, 51, 0.5)
	if [[ ! "$input" =~ ^rgba?\(([0-9]+),[[:space:]]*([0-9]+),[[:space:]]*([0-9]+)(,[[:space:]]*([0-9]*\.?[0-9]+))?\)$ ]]; then
		echo "Invalid RGB(A) format" >&2
		return 1
	fi

	local red=${BASH_REMATCH[1]}
	local green=${BASH_REMATCH[2]}
	local blue=${BASH_REMATCH[3]}
	local alpha=${BASH_REMATCH[5]:-1} # Default alpha to 1 if missing

	# Ensure values are in range
	for channel in "$red" "$green" "$blue"; do
		if ((channel < 0 || channel > 255)); then
			echo "RGB values must be between 0 and 255" >&2
			return 1
		fi
	done

	# Convert alpha from 0-1 to 0-255
	if [[ "$alpha" == "1" ]]; then
		alpha=255
	elif [[ "$alpha" == "0" ]]; then
		alpha=0
	else
		alpha=$(awk "BEGIN {printf \"%d\", ($alpha * 255) + 0.5}") # Round properly
	fi

	# Convert to uppercase hex
	printf "#%02X%02X%02X%02X\n" "$red" "$green" "$blue" "$alpha"
}

# Detect input format and call the appropriate function
process_input() {
	local input="$1"

	if [[ "$input" =~ ^#?[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$ ]]; then
		convert_hex_to_rgba "$input"
	elif [[ "$input" =~ ^rgba?\( ]]; then
		convert_rgba_to_hex "$input"
	else
		echo "Unrecognized format: $input" >&2
		return 1
	fi
}

# Read input from CLI argument or stdin
if [[ -n "$1" ]]; then
	process_input "$1"
else
	while IFS= read -r input; do
		process_input "$input"
	done
fi
