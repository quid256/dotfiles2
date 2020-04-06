#!/usr/bin/env python3

from subprocess import run


def r(command):
    return run(command, shell=True, capture_output=True)


class Commander:
    def update_grub(self):
        """ run update-grub """
        r("konsole -e sudo update-grub")

    def deactivate_monitor(self):
        """ deactivate unused monitors """
        s = r("xrandr | awk '/ disconnected/ {print $1}'")
        closed_monitors = s.stdout.decode('utf-8').strip().split('\n')
        for cm in closed_monitors:
            r("xrandr --output {mon} --off".format(mon=cm))

if __name__ == '__main__':
    commands = [cmd for cmd in dir(Commander) if not cmd.startswith('_')]
    res = r("echo \"{}\" | rofi -sep '|' -dmenu -p \"cmd\"".format("|".join(commands)))

    getattr(Commander, res.stdout.decode('utf-8').strip())(None)

