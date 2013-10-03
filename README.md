## Development Quick Start

### Local Development Server

1. [Install rvm](https://github.com/sstephenson/rbenv#installation), note the homebrew option for OSX.
2. Install ruby 2.0 with `rbenv install 2.0.0`.
3. Install [node](http://nodejs.org/download/), again for OSX, consider [brew](http://madebyhoundstooth.com/blog/install-node-with-homebrew-on-os-x/).
4. Follow below instructions:

```shell
git clone https://github.com/code-dot-org/dashboard.git
cd dashboard
bundle install
rake db:create db:migrate seed:all blockly:latest
cd public/blockly
npm install
grunt
cd ../..
rails s[erver]
open http://localhost:8000
```

### Developing on Blockly Mooc

First, checkout and build blockly-mooc. See [its readme][1] for instructions.

Then configure the dashboard to use your development version:

```shell
rake blockly:dev['/path/to/blockly-mooc']
```

[1]: https://github.com/code-dot-org/blockly/blob/master/README.md

### Vagrant VM

__Note__: The instructions below are incomplete and manual debugging and configuration is required.

This setup mirrors the actual production environment.

```shell
vagrant up
vagrant ssh
cd /vagrant
bin/rake db:create db:migrate seed:all
bin/rails server
```

Then navigate to `http://192.168.60.10:3000/`.
