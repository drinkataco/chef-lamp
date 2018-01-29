# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Vagrant and Chef configuration
  VAGRANT_JSON = JSON.parse(Pathname(__FILE__).dirname.join('nodes', 'vagrant.template.json').read)

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.network "private_network", ip: "192.168.3.77"

  # NFS File sharing
  config.vm.synced_folder VAGRANT_JSON['app']['mount_dir'], VAGRANT_JSON['app']['web_dir'], type: "nfs"

  config.vm.provision :chef_solo do |chef|
     chef.cookbooks_path = ["site-cookbooks", "cookbooks"]
     chef.roles_path = "roles"
     chef.data_bags_path = "data_bags"
     chef.provisioning_path = "/tmp/vagrant-chef"

     # You may also specify custom JSON attributes:
     chef.run_list = VAGRANT_JSON.delete('run_list')
     chef.json = VAGRANT_JSON
  end
end
