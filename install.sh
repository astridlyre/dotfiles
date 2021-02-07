#!/bin/bash

DFDIR="$(pwd)"

install_file() {
  if [ -e "$1" ]; then
    cp "$1" "$HOME/$1"
    echo "Installed $1"
  fi
}

install_file test
