#!/bin/zsh
dirs=(
  # src              dest
  ~/.zshenv         ./zsh/
  ~/.zshrc          ./zsh/
  ~/.zprofile       ./zsh/
  ~/.dir_colors     ./zsh/
  ~/.profile        ./zsh/
  ~/.bashrc_addon   ./zsh/
  ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml                    ./xfce4/
  ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml              ./xfce4/
  ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml            ./xfce4/
  ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml ./xfce4/
  ~/bin/redshift_schedule.sh ./home.bin
  ~/bin/autostart.sh ./home.bin
  ~/bin/restime.sh   ./home.bin
  ~/bin/timer.sh     ./home.bin
  ~/bin/xmice.sh     ./home.bin
  ~/bin/xmice        ./home.bin
  ~/.config/nano/nanorc ./nano
)
for k v in "${(@kv)dirs}"; do
  # if not exist dest dir, create it
  ! [[ -e $v ]] && mkdir -p $v
  # copy should only replace newer file
  cp -uvi $k $v
done
