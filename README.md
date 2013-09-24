dashboard
=========

Home for student and teacher dashboards

## Development Quick Start

### Local Development Server

```
git clone --recursive https://github.com/code-dot-org/dashboard.git
cd dashboard
rails s[erver]
open http://localhost:8000
```

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
