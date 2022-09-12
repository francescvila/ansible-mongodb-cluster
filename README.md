# Table of Contents
1. [About The Project](#about-the-project)
    * [Built With](#built-with)
2. [Getting Started](#getting-started)
    * [Prerequisites](#prerequisites)
    * [Installation](#installation)
3. [Usage](#usage)
4. [Test](#test)
5. [Changelog](#changelog)
6. [License](#license)
7. [Links](#links)

## About The Project

This is an ansible project for locally configuring and testing a cluster three MongoDB nodes.
This project has been tested on Vagrant virtual machines using Debian GNU/Linux 10.x Buster/Stable Minimal Install (64 bit) as VM box image.
It is perfectly valid for configuring a cluster of three remote servers, by changing the hosts IP addresses and creating an ansible user and granting access.


### Built With

Vagrant and VirtualBox are used to easily create local virtual machines.
Ansible playbooks are used to manage configuration on the virtual machines.
Jinja2 templating engine is used to customize remote configuration files.

## Getting Started

Jinja is a web template engine for the Python programming language. It is a text-based template language and thus can be used to generate any markup as well as source code.

Vagrant is an open-source software product for building and maintaining portable virtual software development environments. It tries to simplify the software configuration management of virtualization in order to increase development productivity. Vagrant needs the VirtualBox to be installed on the same machine than Vagrant.

Ansible is an open-source software provisioning, configuration management, and application-deployment tool enabling infrastructure as code. It runs on many Unix-like systems. It includes its own declarative language to describe system configuration. Ansible is agentless, temporarily connecting remotely via SSH to do its tasks.


### Prerequisites

We'll install VirtualBox, Vagrant and Ansible on Ubuntu.
Ubuntu builds are available in a PPA.
To configure the PPA on your machine and install Ansible run these commands:
```sh
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
```

### Installation

In order to run ansible playbooks, ansible must me installed locally.
See the Official Ansible Latest Installation Guide and Jinja2 Templating User Guide links in the links section.
See also how to install Ansible on Ubuntu 20.04 LTS.

With VirtualBox and Vagrant some virtual machines will be created. Ansible playbooks will configure on them all is needed to test.
Find how to install VirtualBox and Vagrant in the links section.

**VAGRANT**

Vagrant can be used to to boot a Linux virtual machine inside your laptop and use it as a server to test Ansible playbooks.

Vagrant needs the VirtualBox virtualizer to be installed on your machine.

Install the VirtualBox package with (Debian):
```sh
sudo apt update
sudo apt install virtualbox
```

Optionally install the extension pack with (Debian):
```sh
sudo apt install virtualbox-ext-pack
```

Install the VirtualBox package with (Debian):
```sh
sudo apt update
sudo apt install vagrant
```

Check Vagrant installation:
```sh
vagrant --version
```


VirtualBox has made a change (restriction) to the default allowed network ranges. The allowed ranges go from 192.168.56.0/21 to 192.168.63.0/21. This behaviour can be overridden by creating a /etc/vbox/networks.conf file on the host filesystem with the following contents to unlock all allowed ranges:
```sh
* 0.0.0.0/0 ::/0
```

We'll go with the 192.168.60.0/24 range.

Create a new host network adapter with IPv4 address/mask 192.168.60.0/24. The DHCP server can be disabled.
```sh
VBoxManage hostonlyif create
VBoxManage hostonlyif ipconfig <name> --ip 192.168.60.1 --netmask 255.255.255.0
vboxmanage dhcpserver modify --ifname <name> --disable
```

You can list host-only network interfaces:
```sh
VBoxManage list hostonlyifs
```

Create/start up vagrant machines by using:
```sh
vagrant up ([hostname1] [hostname2])
```

Stop vagrant machines by using:
```sh
vagrant halt ([hostname1] [hostname2])
```

Stop and destroy vagrant machines by using:
```sh
vagrant destroy ([hostname1] [hostname2])
```

You can SSH to a vagrant machine by using:

```sh
vagrant ssh [hostname]
```

All provisioned vagrant hosts are defined in the file named 'Vagrantfile'.

You can check the status of all VMs created with Vagrant:
```sh
vagrant global-status
```

**ANSIBLE**

The ansible config file (ansible.cfg) has been set to log in the vagrant instancies with the user name 'vagrant', using de same SSH private key file (~/.vagrant.d/insecure_private_key). So, I won't be necessary to create a specific user to SSH from the Ansible control node (your machine).

Ansible hosts are remote servers that are monitored and controlled by the Ansible control node.

Let's install Ansible.
* Make sure your system’s package index is up to date. Refresh the package index with the command:
```sh
sudo apt update
```
* Install Ansible on Ubuntu with the command:
```sh
sudo apt install ansible
```
Remote hosts (the vagrant instances) are defined in the hosts file (inventories/vagrant/hosts).
Every folder under the inventories folder define an environment.
In our case, we only have one environment: vagrant.
Each enviroment has its group_vars folder with the definition of variables for every role.
Each role represents a group of servers by role: all, proxy, web.
The role 'all' applies to all of the roles.

The 'inventories/vagrant' directory has been defined in the ansible.cfg file as the inventory by default.

You can check the accessible hosts by using:
```sh
ansible-inventory --list -y
```
The final step is making sure the Ansible control node connects to the remote hosts and run commands.

* To test the connection with the hosts, use the following command in the terminal on your control node:
```sh
ansible all -m ping
```

* You can also check remote hostname by using:
```sh
ansible all -m setup -a 'filter=ansible_hostname'
```

## Usage

When using Vagrant and VirtualBox to create virtual machines and Ansible as the provisioner, you can create and provision the VMs at the same time:
```sh
vagrant up --provision
```

You can specify different hostnames:
```sh
vagrant up mongo1 mongo2 mongo3 --provision
```

If any config change is made you can provision the VMs again:
```sh
vagrant provision
```

You can specify different hostnames:
```sh
vagrant provision mongo1 mongo2 mongo3
```

If you are not using Vagrant and VirtualBox, to provision and configure all specified hosts run de command:
```sh
ansible-playbook main.yml
```

All existing tags, if any, can be listed by using:
```sh
ansible-playbook main.yml --list-tags
```

While executing ansible-playbook you can refere to its specific groups of hosts and roles. For example:
```sh
ansible-playbook main.yml --limit mongodb

```
To encrypt this file execute the command:
```sh
ansible-vault encrypt --vault-password-file=[vault_password_file] [filepath]
```
To decrypt this file execute the command:
```sh
ansible-vault decrypt --vault-password-file=[vault_password_file] [filepath]
```

To view this file execute the command without decrypting it:
```sh
ansible-vault view --vault-password-file=[vault_password_file] [filepath]
```

To edit this file execute the command without decrypting it:
```sh
ansible-vault edit --vault-password-file=[vault_password_file] [filepath]
```

Introduce de same password you store in the [vault_password_file] file.

**Never push to a git repository the secrets file unencrypted.**

## Test

Let's check if the machines provisioned do what they are suposed to.

The database cluster is based on MongoDB servers set up in a replica set configuration.
Authentication between instances in the replica set is set up with an SSL keyfile.

Check MongoDB connectivity on each cluster node:
```sh
nc -vz 192.168.60.41 27017
nc -vz 192.168.60.42 27017
nc -vz 192.168.60.43 27017
```

Once the instances are created and started up, the replica set configuration has to be applied from any of the cluster nodes.
```sh
vagrant ssh mongo1 -c "sudo docker exec mongodb /scripts/rs-init.sh"
```

After 10 seconds admin and application users can be created.
```sh
vagrant ssh mongo1 -c "sudo docker exec mongodb /scripts/mongo-init.sh"
```

Replica set status can be checkout out executing the command from your local terminal:
```sh
docker run -it mongo:5.0 mongo --host 192.168.60.41 -u root -p <password> --eval "rs.status()"
```

It can also be checkout out from any of the cluster nodes.
```sh
vagrant ssh mongo1 -c "sudo docker exec mongodb mongo -u root -p <password> --eval \"rs.status()\""
```

If you want to add/remove nodes to/from the replica set you can edit and execute the rs-reconfig.sh script from the primary node.
```sh
vagrant ssh mongo1 -c "sudo docker exec mongodb /scripts/rs-reconfig.sh"
```

You can log into mongodb as root by doing:
```sh
vagrant ssh mongo1 -c "sudo docker exec -it mongodb mongo -u root -p <password> --authenticationDatabase admin"
```

You can set down an instance as a MongoDB primary node executing:
```sh
vagrant ssh mongo1 -c "sudo docker exec mongodb mongo -u root -p <password> --eval \"rs.stepDown()\""
```

You can freeze an instance and prevent it from being voted as MongoDB primary node executing:
```sh
vagrant ssh mongo2 -c "sudo docker exec mongodb mongo -u root -p <password> --eval \"rs.freeze()\""
```

If we, for instance, freeze node db2 and step down node db1, we will have node db3 promoted as primary node.

If one node of the cluster of three crashes then any of the other two instances will became a primary node.
If the first node is restored then it might became again the primary node of the cluster.
In a cluster of three nodes we always must have at least two nodes up an running.
MongoDB needs a majority of two in order to vote a new primary node.

In our database cluster the MongoDB connection string should be:

Root auth: mongodb://root:<password>@192.168.60.41:27017,192.168.60.42:27017,192.168.60.43:27017
Admin auth: mongodb://admin:<password>@192.168.60.41:27017,192.168.60.42:27017,192.168.60.43:27017
App user auth: mongodb://appusr:<password>@192.168.60.41:27017,192.168.60.42:27017,192.168.60.43:27017

You can test this connection strings using MongoDB Compass GUI application.
MongoDB compass download link: https://www.mongodb.com/try/download/compass

## Changelog

A changelog is a file which contains a curated, chronologically ordered list of notable changes for each version of a project. See `CHANGELOG.md` to follow all software changes of this project.

## License

Distributed under the Apache License 2.0. See `LICENSE.txt` for more information.

## Links

* Ansible Latest Installation Guide: https://docs.ansible.com/ansible/latest/installation_guide/index.html
* Jinja2 Templating Docs: https://docs.ansible.com/ansible/latest/user_guide/playbooks_templating.html
* Install Ansible on Ubuntu 20.04 LTS: https://linuxhint.com/install_ansible_ubuntu/
* How to Install and Configure Ansible on Ubuntu 20.04: https://phoenixnap.com/kb/install-ansible-ubuntu-20-04
* Working With Playbooks. Ansible Best Practices: https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html
* How to Install Vagrant and use it with VirtualBox on Ubuntu 20.04: https://www.howtoforge.com/how-to-install-vagrant-on-ubuntu-20-04
