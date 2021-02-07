#!/bin/bash

# Auto completion
[[ $- == *i* ]] && source "$HOME/.fzf/completion.bash" 2> /dev/null

# Key bindings
source "$HOME/.fzf/key-bindings.bash"
