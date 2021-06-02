#!/bin/sh
/usr/bin/prime-offload & # Start optimus manager

export QT_AUTO_SCREEN_SCALE_FACTOR=1 # Scaling fix for QT
export AWT_TOOLKIT=MToolkit          # Fixes for Java Apps
export _JAVA_AWT_WM_NONREPARENTING=1 # Fixes for ghidra

# Merge Xresources
[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"

# Start bspwm
exec bspwm
