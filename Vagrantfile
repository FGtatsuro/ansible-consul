# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "mvbcoding/awslinux"

  config.vm.define "server" do |server|
    server.vm.network "private_network", ip: "192.168.50.2"
    server.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "client" do |client|
    client.vm.network "private_network", ip: "192.168.50.3"
    client.vm.synced_folder ".", "/vagrant", disabled: true
  end
end
