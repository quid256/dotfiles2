#!/usr/bin/env python3

from subprocess import run


def r(command):
    return run(command, shell=True, capture_output=True)

class Shutdowner:
    def shutdown(self):
        r("systemctl poweroff")

    def reboot(self):
        r("systemctl reboot")

    def logout(self):
        r("i3-msg exit")

    def lock(self):
        r("i3lock")

    def suspend(self):
        r("systemctl suspend")

    def lock_suspend(self):
        r("i3lock && systemctl suspend")



if __name__ == '__main__':

    options = [s for s in dir(Shutdowner) if not s.startswith("_")]

    res = r("echo \"{}\" | rofi -sep '|' -dmenu -p \"Shutdown\"".format("|".join(options)))

    if res.returncode == 0:
        getattr(Shutdowner, res.stdout.decode('utf-8').strip())(None)
