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
|consul_config_src_dir|Directory including Consul config files on local. Config files are copied to `consul_config_remote_dir` directory on remote.|str|It isn't defined in default. No Consul config file is copied to remote.|
|consul_config_remote_dir|Directory including Consul config files on remote. In almost cases, this value will be passed with `-config-dir` option of Consul.|str|/etc/consul.d|
|consul_config_owner|User of `consul_config_remote_dir` directory and Consul config files under it.|str|root|
|consul_config_group|Group of `consul_config_remote_dir` directory and Consul config files under it.|str|root|
|consul_script_remote_dir|Directory including run/daemon scripts on remote.|str|/opt/consul|

- The value of `consul_config_src_dir` is used as 'src' attribute of Ansible copy module. Thus, whether this value ends with '/' affects the behavior. (Ref. http://docs.ansible.com/ansible/copy_module.html)
- The values of `consul_config_remote_dir`, `consul_config_owner`, and `consul_config_group` are ignored when `consul_config_src_dir` isn't defined.

### Only Debian/Alpine Linux

If you want to overwrite values, please also check https://www.consul.io/downloads.html.

|name|description|type|default|
|---|---|---|---|
|consul_download_url|Download URL of Consul archive.|str|https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip|
|consul_sha256|SHA256 signature of Consul archive.|str|b350591af10d7d23514ebaa0565638539900cdb3aaa048f077217c4c46653dd8|
|consul_download_tmppath|File path downloaded Consul archive is put temporary.|str|/tmp/consul.zip|
|consul_bin_dir|Directory path Consul binary is put|str|/usr/local/bin|

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
