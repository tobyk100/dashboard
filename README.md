dashboard
=========

Home for student and teacher dashboards

## Development Quick Start

The dashboard utilizes [blockly](https://github.com/code-dot-org/blockly) as a git [submodule](http://git-scm.com/book/en/Git-Tools-Submodules). As you work you may have to push to two repositories, this one and [blockly](https://github.com/code-dot-org/blockly).

### Local Development Server

```shell
git clone --recursive https://github.com/code-dot-org/dashboard.git
cd dashboard
bundle
rake db:create db:migrate seed:all blockly:latest
cd public/blockly
grunt
grunt dev
cd ../..
rails s[erver]
open http://localhost:8000
```

- We are running two servers, a rails server and a grunt server. The grunt server watches the file system and recompiles Blockly if any source files change.

### Vagrant VM

This setup mirrors the actual production environment.

```shell
vagrant up
vagrant ssh
cd /vagrant
bin/rake db:create db:migrate seed:all
bin/rails server
```

Then navigate to `http://192.168.60.10:3000/`.

### Developing on Blockly Mooc

First, checkout and build blockly-mooc. See [its readme][1] for instructions.

Then configure the dashboard to use your development version:

```shell
rake blockly:dev['/path/to/blockly-mooc']
```

[1]: https://github.com/code-dot-org/blockly/blob/master/README.md
