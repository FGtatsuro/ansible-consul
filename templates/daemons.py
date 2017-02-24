#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# https://docs.python.org/3.5/howto/pyporting.html#prevent-compatibility-regressions
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import click
import os
import signal
import subprocess
import sys

import daemon
from lockfile.pidlockfile import PIDLockFile

stdout = open('{{ consul_daemon_log_dir }}/stdout.log', mode='a+')
stderr = open('{{ consul_daemon_log_dir }}/stderr.log', mode='a+')
pidfile = PIDLockFile('{{ consul_daemon_pid_dir }}/consul.pid')

cli_context_settings = dict(help_option_names=['-h', '--help'])


def do_start(mode):
    commands = ['{{ consul_script_remote_dir }}/services.sh', mode]
    with daemon.DaemonContext(stdout=stdout, stderr=stderr, pidfile=pidfile):
        child_process = subprocess.Popen(commands)
        child_process.communicate()
        child_process.terminate()


def do_stop():
    pid = pidfile.read_pid()
    if not pid:
        stderr.write(
            "Stop operation is failed. Now, daemon process isn't running.\n")
        stderr.flush()
        sys.exit(1)
    pgid = os.getpgid(pidfile.read_pid())
    os.killpg(pgid, signal.SIGTERM)


@click.group(context_settings=cli_context_settings)
def consul_cli():
    '''
    CLI to manage Consul daemon processes.
    '''
    pass


@consul_cli.command()
@click.argument('mode', type=click.Choice(['dev', 'client', 'server']))
def start(mode):
    '''
    Start Consul daemon processes on MODE(dev/client/server).
    '''
    do_start(mode)


@consul_cli.command()
def stop():
    '''
    Stop Consul daemon processes.
    '''
    do_stop()


@consul_cli.command()
@click.argument('mode', type=click.Choice(['dev', 'client', 'server']))
def restart(mode):
    '''
    Restart Consul daemon processes on MODE(dev/client/server).
    '''
    do_stop()
    do_start(mode)

if __name__ == '__main__':
    consul_cli()
