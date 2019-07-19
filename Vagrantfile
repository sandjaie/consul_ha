$script = <<-SCRIPT
echo -e "LANG=\"en_US.UTF-8\"\nLC_CTYPE=\"en_US.UTF-8\"\nLC_ALL=\"en_US.UTF-8\"" > /etc/default/locale
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.define "server1" do |server1|
    server1.vm.hostname = "server-1"
    server1.vm.box = "ubuntu/xenial64"
    #server1.vm.synced_folder "/Users/sandjaier/testws", "/home/vagrant/testws/"
    server1.vm.network "private_network", type: "dhcp"
  end
  config.vm.define "server2" do |server1|
    server1.vm.hostname = "server-2"
    server1.vm.box = "ubuntu/xenial64"
    #server1.vm.synced_folder "/Users/sandjaier/testws", "/home/vagrant/testws/"
    server1.vm.network "private_network", type: "dhcp"
  end
  config.vm.define "server3" do |server1|
    server1.vm.hostname = "server-3"
    server1.vm.box = "ubuntu/xenial64"
    #server1.vm.synced_folder "/Users/sandjaier/testws", "/home/vagrant/testws/"
    server1.vm.network "private_network", type: "dhcp"
  end
  config.vm.provision "shell",
      inline: $script
  config.vm.provider "virtualbox" do |vb|
    #vb.name = "consul-server"
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
end
