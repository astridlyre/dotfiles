#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

$HOME/.config/polybar/launch.sh &

dex $HOME/.config/autostart/arcolinux-welcome-app.desktop
xsetroot -cursor_name left_ptr &
xset r rate 250 110
setxkbmap -option ctrl:nocaps
run xcape -e 'Control_L=Escape' &
run sxhkd -c ~/.config/bspwm/sxhkd/sxhkdrc &

run nm-applet &
run pamac-tray &
run xfce4-power-manager &
numlockx on &
blueberry-tray &
picom --config $HOME/.config/bspwm/picom.conf &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
run volumeicon &

NUMMON=$(xrandr --query | rg " connected" | cut -d" " -f1 | wc -l)
if [ $NUMMON -eq 2 ]; then
  run /home/ml/.bin/dm-do
else
  run /home/ml.bin/sm-do
fi

feh --bg-fill ~/Pictures/bg.jpg &
