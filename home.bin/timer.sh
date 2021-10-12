#!/bin/bash
# ################[timer.sh]################
# CountDown:
#   $ timer.sh -1800
# CountUp:
#   $ timer.sh 1800
# CountUp from zero:
#   $ timer.sh
# Useful alias:
#   alias timer30m='timer.sh -1800'
# ############################################
# https://stackoverflow.com/questions/5861428/bash-script-erase-previous-line

fn="countup"
save=$1
# if no args provide default countup from 0
[[ -z $1 ]] && save=0
# if args1 smaller than zero, countdown from it's postive seconds
if [[ $save -lt 0 ]]; then
  fn="countdown"; save=$((save * -1))
fi
cnt=$save

displaytime(){
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  printf "\033[0K\r"
  if [[ $fn == "countdown" ]]; then
    printf '%6.2f%%  ' $(echo "scale=4;100*(1-$1/$save)" | bc)
    displayprogress $(echo "scale=2;1-$1/$save" | bc)
  elif [[ $fn == "countup" ]]; then
    printf '(%s) ' $1
  fi
  [[ $D > 0 ]] && printf '%2d days ' $D
  [[ $H > 0 ]] && printf '%2d hours ' $H
  [[ $M > 0 ]] && printf '%2d minutes ' $M
  [[ $D > 0 || $H > 0 || $M > 0 || $S -ge 0 ]] \
  && printf '%2d seconds ' $S
}

# args1 is percent
displayprogress(){
  printf '['
  # echo $1
  space=$(($(tput cols)-52))
  fin_time=$(printf "%.0f" $(echo "scale=0; $1 * $space" | bc))
  pre_time=$(($space - $fin_time))
  for (( i=0;  i<$fin_time; i++ )); do
    printf '='
  done
  for (( i=0;  i<$pre_time; i++ )); do
    printf ' '
  done
  printf '] '
}

while (($cnt > -1)); do
  # clear
  displaytime $cnt
  sleep 1
  if [[ $fn == "countdown" ]]; then
    cnt=$(($cnt-1))
  elif [[ $fn == "countup" ]]; then
    cnt=$(($cnt+1))
  fi
done
