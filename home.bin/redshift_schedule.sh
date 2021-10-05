#!/bin/bash
declare -A redshift_schedule  # associative array
# BeyondTime | ScreenBrightness(0.1-1.0) | ColorTemperature(1000-25000)
redshift_schedule[17:00]=" -b 0.9 -t 5700:5700"
redshift_schedule[18:00]=" -b 0.8 -t 5300:5300"
redshift_schedule[19:00]=" -b 0.8 -t 5000:5000"
redshift_schedule[20:00]=" -b 0.7 -t 4700:4700"
redshift_schedule[21:00]=" -b 0.5 -t 4300:4300"
redshift_schedule[22:00]=" -b 0.3 -t 3700:3700"
redshift_schedule[23:00]=" -b 0.2 -t 3000:3000"

while true ; do
    gap=3600
    redshift_params=
    # https://devhints.io/bash
    for key in "${!redshift_schedule[@]}"; do
        # https://stackoverflow.com/questions/26432050/bash-convert-string-to-timestamp
        time_now=$(date +%s)
        time_point=$(date -d $key +%s)
        next_change_time=$(expr $time_now - $time_point)
        # echo $key
        if (( $next_change_time < gap )); then
            redshift_params=${redshift_schedule[$key]}
            # echo "run after $key !"
            break
        fi
    done
    if [[ -n redshift_params ]]; then
      killall redshift
      while pgrep -u $UID -x redshift &>/dev/null ; do
        sleep 1 # it takes several seconds to close redshift process
        next_change_time=$(expr $next_change_time - 1)
      done
      redshift ${redshift_schedule[$key]} &
      sleep $next_change_time # wait long
    else
      sleep 60 # check after next minutes
    fi
done
