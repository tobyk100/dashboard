#!/bin/bash

set -e

if [[ -z $DASH_ROOT ]]; then
  export DASH_ROOT=/vagrant
fi

export CDO_HOME=/home/vagrant

if [[ ! -d $CDO_HOME/node-0.10.20 ]]; then
  wget -P $CDO_HOME https://github.com/joyent/node/archive/v0.10.20.tar.gz
  tar -xzvf $CDO_HOME/v0.10.20.tar.gz
  (
    cd $CDO_HOME/node-0.10.20
    ./configure
    make
    sudo make install
  )
fi

# Get and build Blockly
if [[ ! -d $DASH_ROOT/blockly ]]; then
  git clone https://github.com/code-dot-org/blockly.git $DASH_ROOT/blockly
  (
    cd $DASH_ROOT/blockly
    sudo npm install -g grunt-cli
    sudo npm install
    grunt
  )
  ln -s $DASH_ROOT/blockly/dist/ $DASH_ROOT/public/blockly
fi

# Fix binstub issue.
(
  cd $DASH_ROOT
  yes | bundle config --delete bin
  yes | rake rails:update:bin
)
