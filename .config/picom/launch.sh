#!/usr/bin/env bash

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q picom

# Wait until the processes have been shut down
while pgrep -u "$(whoami)" -x picom >/dev/null; do sleep 1; done

picom -b --config=/home/chris/.config/picom/picom.conf
