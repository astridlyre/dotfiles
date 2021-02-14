# some more ls aliases
alias ls="exa -G --color auto --icons -a -s type"
alias ll="exa -l --color always --icons -a -s type"
alias lt="exa -T --color always --icons -a -s type"
alias cat="bat -pp --theme='Sublime Snazzy'"
alias vi="vim"
alias nvim="vim"
alias c="clear"
alias x="exit"
alias python="python3"
alias chx="chmod +x"
alias ducks="du -sh * | sort -hr | head -11"
alias r="ranger"
alias pdate="date +'%d/%m/%y'"
alias fd="fd -H"
alias btc="crypto-query btc"
alias eth="crypto-query eth"
alias ada="crypto-query ada"
alias cx="chmod -x"

openpic() {
  ristretto "$1"
}

# Movement
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias ssn="sudo shutdown now"
alias sr="sudo reboot now"
alias sus="sudo systemctl suspend"

min() {
  nvim -u "$HOME/.config/nvim/init_minimal.vim" "$1"
}
