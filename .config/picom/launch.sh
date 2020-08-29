#!/usr/bin/env bash

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q compton

# Wait until the processes have been shut down
while pgrep -u "$(whoami)" -x compton >/dev/null; do sleep 1; done

# picom -b --blur-method=dual_kawase --blur-strength=100 --config=/home/chris/.config/picom/picom.conf
compton -b --config=$HOME/.config/picom/picom.conf

# --config=/home/chris/.config/picom/picom.conf
