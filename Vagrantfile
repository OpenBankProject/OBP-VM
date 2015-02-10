# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "hashicorp/precise64"

  # Forward the Jetty web server port
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  config.vm.provider "virtualbox" do |vb|
    # Increase the memory size of the vm
    vb.memory = "2048"
    # Use 2 cores
    vb.cpus = 2
    # Use the host DNS resolver to speed up internet access
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  # Install puppet postgres module
  config.vm.provision :shell do |shell|
    shell.inline = "mkdir -p /etc/puppet/modules;
                  puppet module install puppetlabs/postgresql;
                  exit 0;"
  end
  
  # Run puppet
  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
  end
end
