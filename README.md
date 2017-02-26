ansible-consul
====================================

[![Build Status](https://travis-ci.org/FGtatsuro/ansible-consul.svg?branch=master)](https://travis-ci.org/FGtatsuro/ansible-consul)

Ansible role for Consul.

Requirements
------------

The dependencies on other softwares/librarys for this role.

- Debian
- Alpine Linux
- OSX
  - Homebrew (>= 0.9.5)

Role Variables
--------------

The variables we can use in this role.

### Common

|name|description|type|default|
|---|---|---|---|
|consul_config_src_dir|Directory including additional Consul config files on local. Config files are copied to `consul_config_remote_dir` directory on remote.|str|It isn't defined in default. No additional Consul config file is copied to remote.|
|consul_config_remote_dir|Directory including Consul config files on remote. This value will be passed to daemon script as `-config-dir` option of Consul. <br>It's owned by `consul_owner`.|str|/etc/consul.d|
|consul_owner|User of components related to Consul. This user should have the permission to run daemon script.|str|consul|
|consul_group|Group of components related to Consul.|str|consul|

- The value of `consul_config_src_dir` is used as 'src' attribute of Ansible copy module. Thus, whether this value ends with '/' affects the behavior. (Ref. http://docs.ansible.com/ansible/copy_module.html)
- Even if `consul_config_src_dir` isn't defined, `consul_config_remote_dir` has a default config file generated from [./templates/consul_common.json.j2](./templates/consul_common.json.j2).
  The variables related to this default config file are as follows.
  If you want to overwrite these values, please also check https://www.consul.io/docs/agent/options.html

|name|description|type|default|
|---|---|---|---|
|consul_default_config_data_dir|In Consul configuration, it collesponds to [data_dir](https://www.consul.io/docs/agent/options.html#data_dir).|str|/tmp/consul|
|consul_default_config_node_name|In Consul configuration, it collesponds to [node_name](https://www.consul.io/docs/agent/options.html#node_name).|str|It isn't defined in default.|
|consul_default_config_bind_addr|In Consul configuration, it collesponds to [bind_addr](https://www.consul.io/docs/agent/options.html#bind_addr).|str|It isn't defined in default.|
|consul_default_config_client_addr|In Consul configuration, it collesponds to [client_addr](https://www.consul.io/docs/agent/options.html#client_addr).|str|It isn't defined in default.|
|consul_default_config_dns_port|In Consul configuration, it collesponds to [dns in ports](https://www.consul.io/docs/agent/options.html#dns_port).|int|It isn't defined in default.|
|consul_default_config_bootstrap_expect|In Consul configuration, it collesponds to [bootstrap_expect](https://www.consul.io/docs/agent/options.html#bootstrap_expect).|int|It isn't defined in default.|

- If you want to overwrite values, please also check https://www.consul.io/docs/agent/options.html

### Only not-container

These values are related to daemon script of Consul, and these are meaningful on not-container environment.
Container doesn't use daemon script because main program in container must run on foreground.

|name|description|type|default|
|---|---|---|---|
|consul_daemon_log_dir|Directory including log files of daemon(named `stdout.log` and `stderr.log`). <br>It's owned by `consul_owner`.|str|/var/log/consul|
|consul_daemon_pid_dir|Directory including PID file of daemon(named `consul.pid`). <br>It's owned by `consul_owner`.|str|/var/run/consul|
|consul_daemon_script_dir|Directory including daemon script(named `daemons.py`). <br>It's owned by `consul_owner`.|str|/opt/consul|

- It's better to use dedicated directories for `consul_daemon_log_dir` and `consul_daemon_pid_dir`.
  If you use existing directores(ex. `/var/log`, `/var/run`), this role mayn't work well.

### Only Linux

These values are meaningful only on Linux.

|name|description|type|default|
|---|---|---|---|
|consul_download_url|Download URL of Consul archive.|str|https://releases.hashicorp.com/consul/0.7.5/consul_0.7.5_linux_amd64.zip|
|consul_sha256|SHA256 signature of Consul archive.|str|40ce7175535551882ecdff21fdd276cef6eaab96be8a8260e0599fadb6f1f5b8|
|consul_download_tmppath|File path downloaded Consul archive is put temporary.|str|/tmp/consul.zip|
|consul_bin_dir|Directory path Consul binary is put|str|/usr/local/bin|

- `consul_bin_dir` should exist in `PATH` environment variable. Or the daemon script can't work well.
- If you want to overwrite values, please also check https://www.consul.io/downloads.html.

Role Dependencies
-----------------

The dependencies on other roles for this role.

- FGtatsuro.python-requirements

Example Playbook
----------------

    - hosts: all
      roles:
         - { role: FGtatsuro.consul }

Test on local Docker host
-------------------------

This project run tests on Travis CI, but we can also run them on local Docker host.
Please check `install`, `before_script`, and `script` sections of `.travis.yml`.
We can use same steps of them for local Docker host.

Local requirements are as follows.

- Ansible (>= 2.0.0)
- Docker (>= 1.10.1)

License
-------

MIT
