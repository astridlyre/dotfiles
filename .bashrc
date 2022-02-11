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

if [[ -d ~/.exercism/exercism_completion.bash ]]; then
	. ~/.exercism/exercism_completion.bash
fi

# enable programmable completion features
if ! shopt -oq posix; then
	[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
fi

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/bash/__tabtab.bash ] && . ~/.config/tabtab/bash/__tabtab.bash
