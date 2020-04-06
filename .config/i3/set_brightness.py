#!/usr/bin/env python3

import sys
from subprocess import run as r


if __name__ == '__main__':
    assert len(sys.argv) == 2, "Must provide only 1 argument"
    cmd = sys.argv[1]

    if cmd.startswith('+') or cmd.startswith('-'):
        assert cmd.endswith('%'), "Change must end with percentage"
        try:
            plus_pct = float(cmd[:-1])
        except:
            raise "Cannot parse percent increase: '{}'".format(cmd[:-1])

        b_out = r("xrandr --verbose | awk '/Brightness/ {print \"B \" $2} / connected/ {print \"M \" $1}'", capture_output=True, shell=True)
        assert b_out.returncode == 0, "Failed to read brightness and monitor info from xrandr"
        
        xrandr_out = b_out.stdout.decode('utf-8').strip().split('\n')

        b_list = [float(s[2:]) for s in xrandr_out if s.startswith('B ')]
        m_list = [s[2:] for s in xrandr_out if s.startswith('M ')]

        cur_b = sum(b_list) / len(b_list)
        new_b = round(max(0.0, min(1.0, cur_b + plus_pct / 100.0)), 2)

        for m in m_list:
            assert r("xrandr --output {out} --brightness {bn}".format(out=m, bn=new_b), shell=True).returncode == 0
