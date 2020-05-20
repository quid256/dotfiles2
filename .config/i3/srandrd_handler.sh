#!/bin/bash


case "${SRANDRD_OUTPUT} ${SRANDRD_EVENT}" in
    "DP1 connected")
        xrandr --output DP1 --auto --right-of eDP1
        /home/chris/.config/polybar/launch.sh;;
    "DP1 disconnected")
        xrandr --output eDP1 --auto --output DP1 --off
        /home/chris/.config/polybar/launch.sh;;
esac
