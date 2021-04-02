#!/bin/bash

# =========== Functions ===========

# General purpose extractor
ex() {
	if [[ -f "$1" ]]; then
		case $1 in
		*.tar.bz2)	tar xjf "$1"	;;
		*.tar.gz)	tar xzf "$1"	;;
		*.bz2)		bunzip2 "$1"	;;
		*.rar)		unrar x "$1"	;;
		*.gz)		gunzip "$1"		;;
		*.tar)		tar xf "$1"		;;
		*.tbz2)		tar xjf "$1"	;;
		*.tgz)		tar xzf "$1"	;;
		*.zip)		unzip "$1"		;;
		*.Z)		uncompress "$1" ;;
		*.7z)		7z x "$1"		;;
		*.deb)		ar x "$1"		;;
		*.tar.xz)	tar xf "$1"		;;
		*.tar.zst)	unzstd "$1"		;;
		*) echo "'$1' cannot be extracted via ex()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# Easy open a picture
opic() {
	ristretto "$1"
}

# Top disk usage
ducks() {
	du -sh ./* | sort -hr | head -11
}

goose() {
  ssh-add ~/.ssh/id_goosetown
  ssh -p 2220 moonlight@www.fileleak.us
}

min() {
  vim -u "$HOME/.config/nvim/init_minimal.vim" "$@"
}

# =========== Aliases ===========

# Confirm before overwriting
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# ls replacement
alias ls="exa -aG --color=always -s type"
alias ll="exa -al --color=always -s type"
alias lt="exa -aT --color=always -s type"

# cat replacement
alias cat="bat -pp --theme='ansi'"

# vim is my editor
alias vi="vim"
alias nvim="vim"
alias e="vim"

# easy typed common things
alias c="clear"
alias x="exit"
alias n="nnn -c"
alias N="sudo -E nnn -c"
alias python="python3"
alias py="bpython"
alias js="node"
alias r="ranger"
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

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Reboot and shutdown
alias ssn="sudo shutdown now"
alias sr="sudo reboot now"
alias sus="sudo systemctl suspend"

# Get error messages from journalctl
alias jctl="journalctl -p 3 -xb"
