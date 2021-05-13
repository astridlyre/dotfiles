#!/bin/bash

# =========== Functions ===========

# Top disk usage
ducks() {
	du -sh ./* | sort -hr | head -11
}

# minimal editor without coc or vim-go
min() {
  vim -u "$HOME/.config/nvim/init_minimal.vim" "$@"
}

# quick make c file
mk() {
  local fname
  fname="$(ls -- *.c)"
  cc -o "${fname%.c}" "$PWD/$fname"
  "$PWD/${fname%.c}"
}

# Find a service port quickly
port() {
  grep --color=auto -E -i "^$1" /etc/services
}

es() {
  vim "$(which "$@")"
}

# =========== Aliases ===========

# Confirm before overwriting
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -I"
alias su="su --login"

# ls replacement
alias ls="exa -aG --color=always -s type"
alias ll="exa -al --color=always -s type"
alias lt="exa -aT --color=always -s type"

# cat replacement
alias cat="bat -pp --theme='ansi'"
alias bat="bat --theme='ansi'"

# vim is my editor
alias vi="vim"
alias nvim="vim"
alias e="vim"

# easy typed common things
alias c="clear"
alias x="exit"
alias n="nnn -c"
alias python="python3"
alias py="bpython"
alias js="node"
alias pdate="date +'%d/%m/%y'"

# Include hidden files by default
alias fd="fd -H"

# Crypto market stuff
alias btc="crypto-query btc"
alias eth="crypto-query eth"
alias ada="crypto-query ada"

# Time chez Liz
alias liztime="TZ='US/Michigan' date"

# Switcher for optimus
alias opswitch="sudo /usr/bin/prime-switch"

# Color for grep, useful for logs
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Movement
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Reboot and shutdown
alias ssn="sudo shutdown now"
alias sr="sudo reboot now"
alias sus="sudo systemctl suspend"

# Get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Upgrade python packages
alias pip-upgrade="pip freeze --user | cut -d'=' -f1 | xargs -n1 pip install -U"
alias update-neovim="sudo /home/ml/.bin/update-neovim"
alias fedora="ssh-add ~/.ssh/id_fedora-dt; ssh -o IdentitiesOnly=yes -i ~/.ssh/id_fedora-dt nerd@192.168.50.69"
