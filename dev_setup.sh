#!/bin/bash

set -e

# Get and build Blockly
if [[ ! -d $DASH_ROOT/blockly ]]; then
  git clone https://github.com/code-dot-org/blockly.git $DASH_ROOT/blockly
  (
    cd $DASH_ROOT/blockly
    sudo npm install  # Must be executed from same directory as package.json.
    grunt
  )
  ln -s $DASH_ROOT/blockly/dist/ $DASH_ROOT/public/blockly
fi

# Fix binstub issue.
(
  cd $DASH_ROOT
  gem install -v 0.4.2
  yes | bundle config --delete bin
  yes | rake rails:update:bin
)
