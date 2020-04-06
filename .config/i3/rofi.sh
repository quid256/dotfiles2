#!/bin/sh

date >> ~/.config/i3/rofi-log.txt
echo $PATH >> ~/.config/i3/rofi-log.txt

rofi -modi drun -show drun
