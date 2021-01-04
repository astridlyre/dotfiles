# ~/.config/fish/config.fish

# --------------------
# Set variables
# --------------------
set -x EDITOR vim
set fish_greeting

# --------------------
# Aliases
# --------------------
alias ls="exa -G --color auto --icons -a -s type"
alias ll="exa -l --color always --icons -a -s type"
alias cat="batcat -pp --theme=base16"
alias fd="fdfind"
alias vi="nvim"
alias vim="nvim"
alias c="clear"
alias x="exit"
alias python="python3"
alias update="sudo apt update && sudo apt upgrade"
alias chx="chmod +x"
alias ducks="du -sh * | sort -hr | head -11"

# --------------------
# Navigation
# --------------------
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# --------------------
# Functions
# --------------------

# md: Make dir and cd to it
function md
	mkdir -p $argv && cd $argv
end

# Enable vi mode
function fish_user_key_bindings
  fish_vi_key_bindings
end
