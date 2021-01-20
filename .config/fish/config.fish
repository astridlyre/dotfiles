# ~/.config/fish/config.fish

# --------------------
# Set variables
# --------------------
set -x EDITOR vim
set -x VISUAL vim
set -x BAT_THEME gruvbox
set fish_greeting

# --------------------
# Aliases
# --------------------
alias ls="exa -G --color auto --icons -a -s type"
alias ll="exa -l --color always --icons -a -s type"
alias lt="exa -T --color always --icons -a -s type"
alias cat="bat -pp --theme=gruvbox"
alias vi="vim"
alias nvim="vim"
alias c="clear"
alias x="exit"
alias python="python3"
alias chx="chmod +x"
alias ducks="du -sh * | sort -hr | head -11"
alias nnn="nnn -eE"
alias r="ranger"
alias fd="fdfind"

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

