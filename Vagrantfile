# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "mvbcoding/awslinux"

  config.vm.define "server" do |server|
    config.vm.network "private_network", ip: "192.168.50.2"
    server.vm.synced_folder ".", "/vagrant", disabled: true

    # https://github.com/puphpet/puphpet/issues/2462
    # http://stackoverflow.com/questions/40968297/laravel-homestead-hangs-at-ssh-auth-method-private-key-on-mac
    # http://stackoverflow.com/questions/38463579/vagrant-hangs-at-ssh-auth-method-private-key
    # https://github.com/mitchellh/vagrant/issues/7648
    server.customize ['modifyvm', :id, '--cableconnected1', 'on']
  end

  config.vm.define "client" do |client|
    config.vm.network "private_network", ip: "192.168.50.3"
    client.vm.synced_folder ".", "/vagrant", disabled: true
    client.customize ['modifyvm', :id, '--cableconnected1', 'on']
  end
end
