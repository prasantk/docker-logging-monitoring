# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

auto = ENV['AUTO_START_SWARM'] || false
# Increase numworkers if you want more than 3 nodes
numworkers = 2

# VirtualBox settings
# Increase vmmemory if you want more than 512mb memory in the vm's
vmmemory = 512
# Increase numcpu if you want more cpu's per vm
numcpu = 1

instances = []

(1..numworkers).each do |n| 
  instances.push({:name => "worker#{n}", :ip => "192.168.10.#{n+2}"})
end

manager_ip = "192.168.10.2"
docker_compose_version = "1.17.1"

File.open("./hosts", 'w') { |file| 
  instances.each do |i|
    file.write("#{i[:ip]} #{i[:name]} #{i[:name]}\n")
  end
}

$install_docker_compose = <<EOC
test -e /usr/local/bin/docker-compose || \\
curl -sSL https://github.com/docker/compose/releases/download/#{docker_compose_version}/docker-compose-`uname -s`-`uname -m` \\
  | sudo tee /usr/local/bin/docker-compose > /dev/null
sudo chmod +x /usr/local/bin/docker-compose
EOC

Vagrant.configure("2") do |config|
    config.vm.provider "virtualbox" do |v|
     	v.memory = vmmemory
  	  v.cpus = numcpu
    end

    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :box
    end
    
    config.vm.define "manager" do |i|
      i.vm.box = "ubuntu/xenial64"
      i.vm.hostname = "manager"
      i.vm.network "private_network", ip: "#{manager_ip}"
      i.vm.provision "shell", path: "./provision.sh"
      i.vm.provision "shell", inline: $install_docker_compose
      if File.file?("./hosts") 
        i.vm.provision "file", source: "hosts", destination: "/tmp/hosts"
        i.vm.provision "shell", inline: "cat /tmp/hosts >> /etc/hosts", privileged: true
      end 
      if auto 
        i.vm.provision "shell", inline: "docker swarm init --advertise-addr #{manager_ip}"
        i.vm.provision "shell", inline: "docker swarm join-token -q worker > /vagrant/token"
      end
    end 

  instances.each do |instance| 
    config.vm.define instance[:name] do |i|
      i.vm.box = "ubuntu/xenial64"
      i.vm.hostname = instance[:name]
      i.vm.network "private_network", ip: "#{instance[:ip]}"
      i.vm.provision "shell", path: "./provision.sh"
      if File.file?("./hosts") 
        i.vm.provision "file", source: "hosts", destination: "/tmp/hosts"
        i.vm.provision "shell", inline: "cat /tmp/hosts >> /etc/hosts", privileged: true
      end 
      if auto
        i.vm.provision "shell", inline: "docker swarm join --advertise-addr #{instance[:ip]} --listen-addr #{instance[:ip]}:2377 --token `cat /vagrant/token` #{manager_ip}:2377"
      end
    end 
  end
end
