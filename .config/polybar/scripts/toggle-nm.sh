#!/usr/bin/bash

echo hi
pids=$(xdotool search --name Networks)
if [ -z "$pids" ]
then
    plasmawindowed org.kde.plasma.networkmanagement &
    sleep 1
else
    for pid in $pids; do
        echo $pid
        xdotool windowkill $pid
    done
fi
