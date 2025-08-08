#!/bin/bash

[[ $- != *i* ]] && return # Return if not interactive
#                             _ _       _     _
# _ __ ___   ___   ___  _ __ | (_) __ _| |__ | |_
#| '_ ` _ \ / _ \ / _ \| '_ \| | |/ _` | '_ \| __|
#| | | | | | (_) | (_) | | | | | | (_| | | | | |_
#|_| |_| |_|\___/ \___/|_| |_|_|_|\__, |_| |_|\__|
#                                 |___/
#     /\-/\
#    /a a  \                                 _
#   =\ Y  =/-~~~~~~-,_______________________/ )
#     '^--'          ________________________/
#       \           / my wonderful bashrc
#       ||  |---'\  \
#      (_(__|   ((__|
#
if [[ -d ~/.bashrc.d ]]; then
	# Source files
	for file in ~/.bashrc.d/*; do
		[[ -f ${file} ]] && . "${file}"
	done
	unset file
fi

# enable programmable completion features
if ! shopt -oq posix; then
	[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="$HOME/.sdkman"
#[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
