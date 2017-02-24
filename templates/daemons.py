#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# https://docs.python.org/3.5/howto/pyporting.html#prevent-compatibility-regressions
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os
import signal
import subprocess
import sys

import daemon
from lockfile.pidlockfile import PIDLockFile

stdout = open('{{ consul_daemon_log_dir }}/stdout.log', mode='a+')
stderr = open('{{ consul_daemon_log_dir }}/stderr.log', mode='a+')
pidfile = PIDLockFile('{{ consul_daemon_pid_dir }}/consul.pid')


def do_start(commands):
    with daemon.DaemonContext(stdout=stdout, stderr=stderr, pidfile=pidfile):
        child_process = subprocess.Popen(commands)
        child_process.communicate()
        child_process.terminate()


def do_stop():
    os.killpg(os.getpgid(pidfile.read_pid()), signal.SIGTERM)


def do_restart():
    do_stop()
    do_start()

if __name__ == '__main__':
    base_command = '{{ consul_script_remote_dir }}/services.sh'
    if sys.argv[1] == 'start':
        do_start([base_command] + sys.argv[2:])
    elif sys.argv[1] == 'stop':
        do_stop()
    elif sys.argv[1] == 'restart':
        do_restart()
    else:
        do_start([base_command] + sys.argv[2:])
