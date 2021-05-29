#!/bin/bash

# source bashrc
[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

# Don't source fnm or startx if in TMUX
[[ "$TMUX" ]] && return 0

# fnm
eval "$(fnm env)"

# start X server
[[ -z $DISPLAY ]] && [[ $XDG_VTNR -eq 1 ]] \
	&& exec startx -- -nolisten tcp -keeptty &>"$HOME/.cache/xorg.log"
