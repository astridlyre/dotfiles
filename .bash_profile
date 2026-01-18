#
# ~/.bash_profile
#

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

[[ "$TMUX" ]] && return 0

[[ -z $DISPLAY ]] && [[ $XDG_VTNR -eq 1 ]] && start-hyprland
