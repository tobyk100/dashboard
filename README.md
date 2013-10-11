## Development Quick Start

### Vagrant VM (recommended)

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
2. Install the latest version of [vagrant](http://downloads.vagrantup.com/).

```shell
# Get this repo
git clone https://github.com/code-dot-org/dashboard.git
cd dashboard

# Get Vagrant up and running
vagrant up
vagrant ssh
cd /vagrant

# Configure and run Rails
rake db:create db:migrate seed:all youtube:thumbnails
rails server
```

Then navigate to `http://192.168.60.10:3000/`.

If you are developing in Blockly you should `cd blockly` and run `grunt dev`. This will start a watch server which will recompile Blockly whenever its' source files are edited (and saved).

#### Updating Vagrant VM
cd dashboard
vagrant ssh
cd /vagrant/blockly
git pull
sudo npm install
grunt
cd ..
bundle
rake db:migrate seed:all youtube:thumbnails
rails server

### Local Development Server (Advanced)

__Note__: This is considered advanced since there are hidden dependencies and system configuration may conflict.

1. [Install rbenv](https://github.com/sstephenson/rbenv#installation), note the homebrew option for OSX.
2. Install ruby 2.0 with `rbenv install 2.0.0-p247` and set to global with `rbenv global 2.0.0-p247`.
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
