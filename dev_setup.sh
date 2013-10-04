#!/bin/bash

cd /home/vagrant
git clone git://github.com/ry/node.git
wget https://github.com/joyent/node/archive/v0.10.20.tar.gz
tar -xzvf v0.10.20.tar.gz
cd node-0.10.20
./configure
make
sudo make install

cd /vagrant

# Get and build Blockly
git clone https://github.com/code-dot-org/blockly.git
cd blockly
sudo npm install -g grunt-cli
sudo npm install
grunt
cd ..
ln -s /vagrant/blockly/dist/ /vagrant/public/blockly
