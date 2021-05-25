#!/bin/bash

# source bashrc
[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

# fnm
eval "$(fnm env)"

# start X server
[[ -z "$DISPLAY" ]] && [[ "$XDG_VTNR" -eq 1 ]] && \
  exec startx -- -nolisten tcp -keeptty &> "$HOME/.cache/xorg.log"
