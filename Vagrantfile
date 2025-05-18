# -*- mode: ruby -*-
# vi: set ft=ruby :

NUM_MACHINES = (ENV['NUM_MACHINES'] || 2).to_i
CPU_CTRL = (ENV['CPU_CTRL'] || "2")
MEMORY_CTRL = (ENV['MEMORY_CTRL'] || "4096")
CPU_NODES = (ENV['CPU_NODES'] || "2")
MEMORY_NODES = (ENV['MEMORY_NODES'] || "6144")


inventory = "[mygroup]\n"

inventory += "ctrl ansible_host=192.168.56.100 ansible_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/ctrl/virtualbox/private_key\n"

(1..NUM_MACHINES).each do |i|
  hostname = "node-#{i}"
  ip = "192.168.56.#{100 + i}"

  inventory += "#{hostname} ansible_host=#{ip} ansible_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/#{hostname}/virtualbox/private_key\n"
end

# Make sure to write the inventory to a file!
File.write("ansible/inventory.cfg", inventory)

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

  config.vm.provision :ansible do |ansible|
    ansible.compatibility_mode ="2.0"
    ansible.playbook = "ansible/general.yaml"
    ansible.extra_vars = {
      num_workers: NUM_MACHINES
    }
  end

  config.vm.define "ctrl" do |ctrl|
    ctrl.vm.network "private_network", ip: "192.168.56.100"

    ctrl.vm.provider "virtualbox" do |vb|
      vb.memory = MEMORY_CTRL
      vb.cpus = CPU_CTRL
    end

    ctrl.vm.provision :ansible do |a|
      a.compatibility_mode = "2.0"
      a.playbook = "ansible/ctrl.yaml"
    end
    ctrl.vm.synced_folder ".", "/vagrant"
  end

  (1..NUM_MACHINES).each do |i|
    hostname = "node-#{i}"
    ip = "192.168.56.#{100 + i}"

    config.vm.define hostname do |node|
      node.vm.hostname = hostname
      node.vm.network "private_network", ip: ip

      node.vm.provider "virtualbox" do |vb|
        vb.memory = MEMORY_NODES
        vb.cpus = CPU_NODES
      end

      node.vm.provision :ansible do |a|
        a.compatibility_mode = "2.0"
        a.playbook = "ansible/node.yaml"
      end
      node.vm.synced_folder ".", "/vagrant"
    end
  end 
end
