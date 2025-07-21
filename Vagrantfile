# ENV['VAGRANT_NO_PARALLEL'] = 'no'
NODE_ROLE = "server"
NODE_BOX = 'generic/ubuntu2004'
NODE_CPUS = 2
NODE_MEMORY = 2048
# Virtualbox >= 6.1.28 require `/etc/vbox/network.conf` for expanded private networks 
# NODE_IP = "10.10.10.100"
NODE_IP = "192.168.56.100"
# SSH_PORT=2220

SSH_KEY_DIR = File.expand_path(".keys", __dir__)
Dir.mkdir(SSH_KEY_DIR) unless Dir.exist?(SSH_KEY_DIR)

SSH_KEY_NAME = "id_rsa_vagrant"
SSH_PRIVATE_KEY_PATH = File.join(SSH_KEY_DIR, SSH_KEY_NAME)
SSH_PUBLIC_KEY_PATH = "#{SSH_PRIVATE_KEY_PATH}.pub"

# Generate SSH key on the host if it doesn't exist
unless File.exist?(SSH_PRIVATE_KEY_PATH) && File.exist?(SSH_PUBLIC_KEY_PATH)
  puts "Generating SSH keypair at #{SSH_PRIVATE_KEY_PATH}"
  system("ssh-keygen -t rsa -b 2048 -f #{SSH_PRIVATE_KEY_PATH} -N ''")
end

def provision(vm, role)
  vm.box = NODE_BOX
  vm.hostname = role
  vm.network "private_network", ip: NODE_IP, netmask: "255.255.255.0"

  # Upload public key BEFORE changing anything
  vm.provision "file", source: SSH_PUBLIC_KEY_PATH, destination: "/home/vagrant/temp_key.pub"

  # Inject SSH key
  vm.provision "shell", inline: <<-SHELL
    mkdir -p /home/vagrant/.ssh
    cat /home/vagrant/temp_key.pub >> /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys
    chown -R vagrant:vagrant /home/vagrant/.ssh
  SHELL

  # Change SSH port and restart
  # vm.provision "shell", privileged: true, inline: <<-SHELL
  #   sudo sed -i 's/^#Port 22/Port #{SSH_PORT}/' /etc/ssh/sshd_config
  #   sudo systemctl restart ssh
  # SHELL

  # vm.network "forwarded_port", guest: 22, host: SSH_PORT, auto_correct: true
  vm.network "forwarded_port", guest: 4000, host: 4000, auto_correct: true
  vm.network "forwarded_port", guest: 4001, host: 4001, auto_correct: true
  vm.network "forwarded_port", guest: 5432, host: 45432, auto_correct: true

  vm.provision "ansible", run: 'once' do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "playbooks/site.yml"
    # ansible.playbook = "playbooks/check_connection.yml"
    ansible.inventory_path = "inventory.yml"
    ansible.extra_vars = {
      var1: "value1"
      # http_proxy: "http://127.0.0.1:2280",
      # https_proxy: "http://127.0.0.1:2280"
    }
  end
end

Vagrant.configure("2") do |config|
  # Default provider is libvirt, virtualbox is only provided as a backup
  config.vm.provider "libvirt" do |v|
    v.cpus = NODE_CPUS
    v.memory = NODE_MEMORY
  end
  config.vm.provider "virtualbox" do |v|
    v.cpus = NODE_CPUS
    v.memory = NODE_MEMORY
    v.linked_clone = true
  end
  
  config.vm.define NODE_ROLE do |node|
    provision(node.vm, NODE_ROLE)
  end

end
