dashboard
=========

Home for student and teacher dashboards

## Development Quick Start

```shell
vagrant up
vagrant ssh
cd /vagrant
bin/rake db:create db:migrate
bin/rails server
```

Then navigate to `http://192.168.60.10:3000/`.
