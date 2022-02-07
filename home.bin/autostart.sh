#!/bin/zsh
if [[ -z "$DISPLAY" ]]; then exit; fi
# xset b off
single_run(){
  # terminate running instances
  pkill -f $1
  # wait until the processes have been shut down
  while pgrep -u $UID -x $1 >/dev/null; do
    sleep 1
  done
  eval "$2"
}

# single_run xfce4-clipman        "xfce4-clipman       &"   # clipboard manager damon
single_run xfce4-power-manager  "xfce4-power-manager &"   # handle display brightness keys
single_run light-locker         "light-locker        &"   # xflock4
single_run fcitx-autostart      "fcitx-autostart     &"   # fcitx Input Method
single_run clipmenud  clipmenud&

single_run restime.sh restime.sh&
single_run dwm_bar    dwm_bar.sh&

# Unload API functions
unset -f single_run

setxkbmap -option caps:swapescape
