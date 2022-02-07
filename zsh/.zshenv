#!/bin/zsh
# 'zshenv' sourced in all zsh sessions
# e.g. including in every zsh scripts
export EDITOR=vim
export VISUAL=vim
export KEYTIMEOUT=1
# export PAGER=
export BROWSER=firefox
export MEDIA_PLAYER=mpv
export IMG_VIEWER=viewnior
export DOC_VIEWER=zathura
# export TERM=xterm-256color
export PATH=$PATH:$HOME/bin # local bin path
export MANPATH=$MANPATH:$HOME/.local/man # /usr/local/man/man1/xxx.1
# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
# zsh
export SHELL=/bin/zsh
# export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$HOME/.zsh_history" # history filepath
export HISTSIZE=9999 # maximum events for internal history
export SAVEHIST=9999 # maximum events in history file
# Misc
# export QT_QPA_PLATFORMTHEME="qt5ct"
# export QT_AUTO_SCREEN_SCALE_FACTOR=0
# export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export GTK_THEME=

# fzf
# export FZF_DEFAULT_OPTS="--height=50% --layout=reverse --info=inline --border \
# --preview='file {}' --preview-window=up,1,border-horizontal \
# --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'"
export FZF_DEFAULT_COMMAND="fd -H --type f --exclude={.git}"
export FZF_DEFAULT_OPTS="--height=50% --layout=reverse --info=inline \
  --tabstop=4 --ansi"
# use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
# export FZF_CTRL_R_OPTS=
export FZF_ALT_C_COMMAND="fd -H --type d --exclude={.git}"
