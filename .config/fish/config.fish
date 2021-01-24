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
alias r="ranger"

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

function fish_mode_prompt
end

if not test $VIM
  spaceinvaders
end
