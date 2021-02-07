#!/bin/sh

#
# ~/.xsession
#
# Executed by xdm/gdm/kdm at login
EXTMON=$(xrandr --query | rg "HDMI-0 connected")

if [ $EXTMON ]; then
  $HOME/.bin/dm-do
else
  $HOME/.bin/sm-do
fi
