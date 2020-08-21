Vagrant.configure("2") do |config|

  config.vm.define "botsv3" do |cfg|
    cfg.vm.box = "bento/ubuntu-20.04"
    cfg.vm.hostname = "botsv3"
    cfg.vm.provision :shell, path: "bootstrap.sh"

    cfg.vm.provider "vmware_desktop" do |v, override|
      v.vmx["displayname"] = "BOTSv3"
      v.memory = 4096
      v.cpus = 2
      v.gui = true
    end

    cfg.vm.provider "virtualbox" do |vb, override|
      vb.gui = true
      vb.name = "PurpleLab-Splunk"
      vb.customize ["modifyvm", :id, "--memory", 4096]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--vram", "32"]
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end
end