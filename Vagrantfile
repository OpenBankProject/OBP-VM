# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "base"
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = File.expand_path("../manifests", __FILE__)
  end 
  config.vm.forward_port 8080, 7070, :auto => true
  config.vm.share_folder "configs", "/configs", File.expand_path("../configs", __FILE__)
end
