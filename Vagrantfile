# -*- mode: ruby -*-
# # vi: set ft=ruby :
# N : Number of nodes per hardware server
N = 1
IMAGE_NAME = "ubuntu/xenial64"
IMAGE_NAME2 = "debian/stretch64"

# Hardware Server NUM
SERVER = 1

# MasterPrivateIP = 192.168.2.m
m = 50 + ( SERVER - 1 ) * 10

# MasterNode Public IP Address
IPADDRESS = "192.168.1.13"

Vagrant.configure(2) do |config|

  config.ssh.insert_key = false
  (1..N).each do |i|

      if i == 1 and SERVER == 1

        vM_NAME = "Server-1-MASTER"


      else


        if SERVER == 1

          vM_NAME = "Server-#{SERVER}-WORKER-#{i-1}"

        else


          vM_NAME = "Server-#{SERVER}-WORKER-#{i}"

        end

      end

    config.vm.define vM_NAME do |s|

      var = '''{"node_ip":"192.168.2.'''.concat("#{i + m - 1}").concat('"}')
      s.ssh.forward_agent = true
      s.vm.box = IMAGE_NAME
      s.vm.hostname = vM_NAME
      s.vm.provider "virtualbox" do |v|

        v.name = vM_NAME
        v.customize ['modifyvm', :id, '--nictype3', '82540EM']
        v.customize ['modifyvm', :id, '--nicpromisc1', 'allow-all']
        v.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
        v.customize ['modifyvm', :id, '--nicpromisc3', 'allow-all']
        v.memory = 2048
        v.memory = 2048
        v.memory = 2048
        v.gui = false

      end


      # A script to install ansible on the Vm
      s.vm.provision :shell, path: "scripts/bootstrap_ansible.sh"


      # Common configuration 
      s.vm.provision :shell, inline: "PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/installations/install-docker-playbook.yml"
      s.vm.provision :shell, inline: "PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/configurations/disable-swap-playbook.yml"
      s.vm.provision :shell, inline: "PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/installations/kubelet-kubeadm-kubectl-playbook.yml --extra-vars '".concat(var).concat("' -c local ")
      s.vm.network "private_network", ip: "192.168.2.#{i + m - 1}",# netmask: "255.255.255.0",

      auto_config: true       



      # Master Node
      if i == 1 and SERVER == 1
        
        if IPADDRESS == ""
          s.vm.network "public_network", bridge: "Intel(R) Ethernet Connection I217-LM", auto_config: true

        else
          s.vm.network "public_network", bridge: "Intel(R) Ethernet Connection I217-LM", ip: IPADDRESS, auto_config: true

        s.vm.provision :shell, inline: "PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/configurations/initialize-kubeadm-playbook.yml"
        s.vm.provision :shell, inline: "PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/configurations/vagrant-user-config-playbook.yml"
        s.vm.provision :shell, inline: "PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/connections/networking-provider-playbook.yml"
        s.vm.provision :shell, inline: "PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/connections/join-command-playbook.yml"

        end

      else
        
        s.vm.provision :shell, inline: "PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/connections/join-nodes-playbook.yml"      

      end

    end

  end


  if Vagrant.has_plugin?("vagrant-cachier")

    config.cache.scope = :box

  end



end

