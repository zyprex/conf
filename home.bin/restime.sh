#!/bin/sh

# ################[restime.sh]################
# Turn On:
#   $ chmod +x ./restime.sh; ./restime.sh&
# Turn Off:
#   $ pkill -f restime.sh
# Auto Start Up:
#   in file '~/.profile', add following line:
#     /path/of/restime.sh&
# ############################################

# check if a cmd exists
type "zenity" > /dev/null || exit
# t[0] work... t[1] rest... t[2] work... t[3] rest...
# and so on... (unit: seconds)
# 25m 5m 25m 5m 25m 5m 20m 10m
t=(1500 300 1500 300 1500 300 1200 600)
t_len=${#t[*]}
# extend work time by 30s
work_increment=60

function turnOffScreen () {
	xset dpms force off
}

function turnOnScreen () {
	xset dpms force on
}

# args1 = flash_times
function flashScreen () {
	for (( i=0; i<$1; i++ )); do
		sleep 0.4
		turnOffScreen
		turnOnScreen
	done
}

# args1 = text
function zenityQ () {
	zenity --title="$0" --question \
		--text="$1" --width=400 --height=80
}

# args1 = sleep_time_sec , args2 = text
function zenityProgress () {
	for (( i=0; i<=$1; i++ )); do
		sleep 1
		echo $(( $i * 100 / $1 ))
		if [ $i -eq 5 ]; then turnOffScreen; fi
		if [ $i -eq $1 ]; then
			echo 100
			turnOnScreen
			break
		fi
	done |
		zenity --title="$0" --progress \
		--text="$2" --width=400 --height=80
		# --auto-close
}

# args1 = rest time
function notifRestState () {
	zenityProgress $1 "Zzz ... "
}

# args1 = work time, args2 = rest time
function notifWorkState () {
	sleep $1
	while true; do
		zenityQ "have a break?\nrest for $(($2/60)) min $(($2%60)) sec"
		if [ $? -eq 0 ]; then break; fi
		sleep $work_increment
	done
}

# main loop
while true; do
	# loop in t[0..n]
	for ((i=0; i<t_len; i++)); do
		if ((i % 2  == 0)); then
			# echo "$i is even, work time ${t[i]} sec"
			notifWorkState ${t[i]} ${t[i+1]}
		else
			# echo "$i is odd, rest time ${t[i]} sec"
			notifRestState ${t[i]}
		fi
	done
done

# vim:set ts=4 sw=4 list:
