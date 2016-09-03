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

|name|description|type|default|
|---|---|---|---|
|consul_download_url|Download URL of Consul archive.|str|https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip|
|consul_sha256|SHA256 signature of Consul archive.|str|abdf0e1856292468e2c9971420d73b805e93888e006c76324ae39416edcf0627|
|consul_download_tmppath|File path downloaded Consul archive is put temporary.|str|/tmp/consul.zip|
|consul_bin_dir|Directory path Consul binary is put|str|/usr/local/bin|

- These variables are valid only on Debian/Alpine Linux, and they aren't used on OSX. On OSX, latest binary is installed by Homebrew.
- If you want to overwrite values, please check https://www.consul.io/downloads.html.

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
