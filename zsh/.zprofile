#!/bin/zsh
# 'zprofile' only sourced when zsh is run as login shell
# e.g. when logging in on the console or via SSH, it 
# usually not be available in an X11 session


# export QT_QPA_PLATFORMTHEME="qt5ct"
# export QT_AUTO_SCREEN_SCALE_FACTOR=0
# export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# export EDITOR=vim
# setxkbmap -option caps:swapescape
#export GTK_THEME="Adwaita-dark"

# load exist autostart.sh
type autostart.sh > /dev/null  && autostart.sh
