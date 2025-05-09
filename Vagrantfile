# -*- mode: ruby -*-
# vi: set ft=ruby :

NUM_MACHINES = (ENV['NUM_MACHINES'] || 2).to_i

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.box_version = "202502.21.0"

  # Sync the keys folder into each VM, so that the VM can authorize each key to use the 'vagrant' user
  config.vm.synced_folder "./keys/", "/vagrant/host_keys"

  # config.vm.provision :ansible do |a|
  #   a.compatibility_mode = "2.0"
  #   a.playbook = "ansible/general.yaml"
  # end
  config.vm.provision "ansible_local" do |ansible|
    ansible.compatibility_mode ="2.0"
    ansible.playbook = "ansible/general.yaml"
  end

  config.vm.define "ctrl" do |ctrl|
    ctrl.vm.network "private_network", ip: "192.168.56.100"

    ctrl.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = "1"
    end

    # ctrl.vm.provision :ansible do |a|
    #   a.compatibility_mode = "2.0"
    #   a.playbook = "ansible/ctrl.yaml"
    # end
  end

  (1..NUM_MACHINES).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "192.168.56.#{100 + i}"

      node.vm.provider "virtualbox" do |vb|
        vb.memory = "6144"
        vb.cpus = "2"
      end

      # node.vm.provision :ansible do |a|
      #   a.compatibility_mode = "2.0"
      #   a.playbook = "ansible/node.yaml"
      # end
    end
  end 
end
