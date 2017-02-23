#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# https://docs.python.org/3.5/howto/pyporting.html#prevent-compatibility-regressions
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import subprocess
import sys

import daemon
import lockfile.pidlockfile

if __name__ == '__main__':
    stdout = open('{{ consul_daemon_log_dir }}/stdout.log', mode='a+')
    stderr = open('{{ consul_daemon_log_dir }}/stderr.log', mode='a+')
    pidfile = lockfile.pidlockfile.PIDLockFile('{{ consul_daemon_pid_dir }}/consul.pid')
    with daemon.DaemonContext(stdout=stdout, stderr=stderr, pidfile=pidfile):
        subprocess.call(['{{ consul_script_remote_dir }}/services.sh'] + sys.argv[1:])
