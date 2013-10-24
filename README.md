## Development Quick Start Readme

### Background
We are building drag-drop programming tutorials to allow a beginner to learn very basic programming concepts (sequencing, if-then statements, for loops, variables, functions), but using drag-drop programming.
The visual language we're using is based on Blockly (and open-source drag-drop language that spits out XML or JavaScript or Python). 


The end-product is a 1-hour tutorial to be used during the Hour of Code campaign, for anybody to get a basic intro to Computer Science, AND a 20-hour follow-on tutorial and teacher-dashboard, meant for use in K-8 (elementary and middle school) classrooms.

For the 1-hour tutorial, we'd like to localize for international use (although we aren't going to get to bi-di support anytime soon). For the 20-hour curriculum, we'd like to have international support too, eventually.
The 1-hour tutorial should work on any browser (including tablets, smartphones), and require no sign-in. The 20-hour tutorial is optimized for desktops and tablets, and requires a login to save state.

Our code is segmented into three parts:

1. "Blockly Core" is the underlying language platform
2. "Blockly" is the individual tutorial puzzles
3. "Dashboard" is the tutorial platform for student login, teacher login, and state

The various areas we'd love engineering help on are:

- [Blockly issues](https://github.com/code-dot-org/blockly/issues)
- [Dashboard issues](https://github.com/code-dot-org/dashboard/issues)

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
```shell
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
```

### Developing on Blockly Mooc

First, checkout and build blockly-mooc. See [its readme][1] for instructions.

Then configure the dashboard to use your development version:

```shell
rake blockly:dev['/path/to/blockly-mooc']
```

[1]: https://github.com/code-dot-org/blockly/blob/master/README.md
