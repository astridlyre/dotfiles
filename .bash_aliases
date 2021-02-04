# some more ls aliases
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

# Movement
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias cleanup="sudo pacman -Rns $(pacman -Qtdq)"
alias ssn="sudo shutdown now"
alias sr="sudo reboot now"
alias sus="sudo systemctl suspend"
