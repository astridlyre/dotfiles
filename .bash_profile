#!/bin/bash
# ~/.bash_profile
#
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start X server
startx -- -keeptty &> ~/.xorg.log
