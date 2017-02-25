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

cli_context_settings = dict(
        help_option_names=['-h', '--help'],
        ignore_unknown_options=True)


def do_start(options):
    # NOTE: Set proper PATH environment to access consul command.
    commands = ['consul', 'agent', '-config-dir={{ consul_config_remote_dir }}'] + options
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
@click.argument('consul_agent_options', nargs=-1, type=click.UNPROCESSED)
def start(consul_agent_options):
    '''Start Consul daemon processes on MODE(dev/client/server).

    This command accepts all options of 'consul agent'. For example,

    \b
    # '--' is needed to pass option-like values to this script.
    daemon.py start -- -dev -bind=192.168.1.3

    1. An option -config-dir={{ consul_config_remote_dir }} is added automatically.

    2. About other options of 'consul agent', please check https://www.consul.io/docs/agent/options.html.
    '''
    do_start(list(consul_agent_options))


@consul_cli.command()
def stop():
    '''Stop Consul daemon processes.'''
    do_stop()


@consul_cli.command()
@click.argument('consul_agent_options', nargs=-1, type=click.UNPROCESSED)
def restart(consul_agent_options):
    '''Restart Consul daemon processes on MODE(dev/client/server).

    This command accepts same options of 'start'.
    '''
    do_stop()
    do_start(list(consul_agent_options))

if __name__ == '__main__':
    consul_cli()
