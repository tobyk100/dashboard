# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "raring64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/20130831/raring-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.network :hostonly, "192.168.60.10"

  config.vm.provision :shell do |shell|
    shell.path = "server_setup.sh"
    shell.args = "-d '/vagrant' 'vagrant'"
  end

  # Enable symlinks. See https://github.com/mitchellh/vagrant/issues/713
  config.vm.customize [
    'setextradata',
    :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root',
    '1'
  ]

end
