VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  # Use the same key for each machine
  config.ssh.insert_key = false
  # Enable SSH with password authentification (for ssh-key-adding)
  # config.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"

  # Provision all VMs with the same cpu and memory config
  # Otherwise, specificy inside config.vm.define
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 1
  end  
  
  # MongoDB servers

  config.vm.define "mongo1" do |mongo1|
    mongo1.vm.box = "debian/buster64"
    mongo1.vm.hostname = "mongo1"
    mongo1.vm.network "private_network", ip: "192.168.60.41"
    mongo1.vm.provision "ansible" do |ansible|
      ansible.inventory_path = "inventories/vagrant"
      ansible.playbook = "main.yml"
    end
  end

  config.vm.define "mongo2" do |mongo2|
    mongo2.vm.box = "debian/buster64"
    mongo2.vm.hostname = "mongo2"
    mongo2.vm.network "private_network", ip: "192.168.60.42"
    mongo2.vm.provision "ansible" do |ansible|
      ansible.inventory_path = "inventories/vagrant"
      ansible.playbook = "main.yml"
    end
  end

  config.vm.define "mongo3" do |mongo3|
    mongo3.vm.box = "debian/buster64"
    mongo3.vm.hostname = "mongo3"
    mongo3.vm.network "private_network", ip: "192.168.60.43"
    mongo3.vm.provision "ansible" do |ansible|
      ansible.inventory_path = "inventories/vagrant"
      ansible.playbook = "main.yml"
    end
  end
end
