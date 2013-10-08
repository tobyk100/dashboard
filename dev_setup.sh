#!/bin/bash

set -e

# Get and build Blockly
if [[ ! -d $DASH_ROOT/blockly ]]; then
  git clone https://github.com/code-dot-org/blockly.git $DASH_ROOT/blockly
  sudo npm install $DASH_ROOT/blockly/package.json
  grunt $DASH_ROOT/blockly/Gruntfile.js
  ln -s $DASH_ROOT/blockly/dist/ $DASH_ROOT/public/blockly
fi

# Fix binstub issue.
(
  cd $DASH_ROOT
  yes | bundle config --delete bin
  yes | rake rails:update:bin
)
