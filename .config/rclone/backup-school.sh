#!/usr/bin/env bash

rclone copy --update --verbose --exclude-from=/home/chris/.config/rclone/school-exclude.txt \
    --transfers=40 --checkers=10 --tpslimit=10 --drive-chunk-size=1M \
    "/home/chris/School/" school-drive:/School/
