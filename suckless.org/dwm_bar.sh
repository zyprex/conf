#!/bin/bash

network_state() {
	network=$(nmcli g | tail -1 | awk '{print$1}')
	if [ "$network" = "connected" ]; then
		net=@ 
	else
		net=
	fi
}

battery_state() {
	bat=$(cat /sys/class/power_supply/BAT1/capacity)
	batterystate=$(cat /sys/class/power_supply/BAT1/status)
	if [ "$batterystate" = "Discharging" ]; then
		bat=$bat%!
	elif [ $bat -gt 95 ]; then
		bat=
	else
		bat=$bat%
	fi
}

network_state
battery_state

while true;
do
    time=$(date '+%Y%m%d-%u-%H:%M:%S.%N')
    tick=$(date '+%S')
    if [ "$tick" = "00" ]; then
	    network_state
	    battery_state
    fi
    xsetroot -name "$net $bat ${time:0:21}"
    sleep 0.1
done

# vim:ft=bash:
