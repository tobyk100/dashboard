## Installation

__Note__: The dashboard utilizes [blockly](https://github.com/code-dot-org/blockly) as a git [submodule](http://git-scm.com/book/en/Git-Tools-Submodules). As you work you may have to push to two repositories, this one and [blockly](https://github.com/code-dot-org/blockly). If you are unfamiliar with submodules, please visit [here](http://git-scm.com/book/en/Git-Tools-Submodules).

### Common instructions.

1. Download and install the latest version of [virtual box](https://www.virtualbox.org/wiki/Downloads) for your OS.
2. Download and install the latest version of [vagrant](http://downloads.vagrantup.com/) for your OS.
3. Clone and cd into directory:
```
git clone --recursive https://github.com/code-dot-org/dashboard.git
cd dashboard
```

3. Continue with OS specific instructions.

### OSX Install

```
vagrant up
vagrant ssh
cd /vagrant
bin/rake db:create db:migrate seed:all
bin/rails server
```

Then navigate to `http://192.168.60.10:3000/`.

### Windows Install
4. `vagrant up`. If vagrant complains that it cannot find virtual box, add it to your path, for __example__: `set PATH=%PATH%;C:\Program Files\Oracle\VirtualBox`, where you should change the path to point to __your__ copy of the git\bin directory.
5. `vagrant ssh`. If the ssh executable cannot be found, make sure to add it to your path, for __example__: `set PATH=%PATH%;C:\Program Files\git\bin`.
