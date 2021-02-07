#!/bin/bash

if [ xrandr | rg "HDMI-0 connected" ]; then
  xrandr --output HDMI-0 --mode 3840x2160 --pos 0x0 --rotate normal --output eDP-1-1 --primary --mode 1920x1080 --pos 3840x1080 --rotate normal
else
  xrandr --auto
fi
