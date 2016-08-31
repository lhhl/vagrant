VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "laravel"
  config.vm.box_url = "laravel.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 5432, host: 5433

  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"

  config.vm.synced_folder "../src", "/data/htdocs", create: true, owner: 'vagrant', group: 'vagrant', mount_options: ['dmode=777,fmode=776']
  config.vm.synced_folder "../db", "/data/db", create: true, owner: 'vagrant', group: 'vagrant', mount_options: ['dmode=777,fmode=776']

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end

  config.vm.provision :shell, path: "provision.sh"
end