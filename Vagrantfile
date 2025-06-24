# ENV['VAGRANT_NO_PARALLEL'] = 'no'
NODE_ROLES = ["server-0"]
NODE_BOXES = ['generic/ubuntu2004']
NODE_CPUS = 2
NODE_MEMORY = 2048
# Virtualbox >= 6.1.28 require `/etc/vbox/network.conf` for expanded private networks 
# NETWORK_PREFIX = "10.10.10"
NETWORK_PREFIX = "192.168.56"

def provision(vm, role, node_num)
  vm.box = NODE_BOXES[node_num]
  vm.hostname = role
  # We use a private network because the default IPs are dynamically assigned 
  # during provisioning. This makes it impossible to know the server-0 IP when 
  # provisioning subsequent servers and agents. A private network allows us to
  # assign static IPs to each node, and thus provide a known IP for the API endpoint.
  node_ip = "#{NETWORK_PREFIX}.#{100+node_num}"
  # An expanded netmask is required to allow VM<-->VM communication, virtualbox defaults to /32
  vm.network "private_network", ip: node_ip, netmask: "255.255.255.0"

  vm.provision "ansible", run: 'once' do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "playbooks/site.yml"
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
    config.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true
  end
  config.vm.provider "virtualbox" do |v|
    v.cpus = NODE_CPUS
    v.memory = NODE_MEMORY
    v.linked_clone = true
    config.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true
  end
  
  NODE_ROLES.each_with_index do |name, i|
    config.vm.define name do |node|
      provision(node.vm, name, i)
    end
  end

end
