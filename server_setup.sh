#!/bin/sh

set -e

export DEBIAN_FRONTEND=noninteractive
aptitude update
aptitude -y install \
  build-essential \
  git \
  mysql-client \
  ruby-dev \
  mysql-server \
  libmysqlclient-dev \
  nginx

gem install bundler
gem install unicorn

bundle install --binstubs

rm -f /etc/nginx/sites-enabled/default
sudo ln -s /home/ubuntu/deploy/config/nginx.conf /etc/nginx/sites-enabled/dashboard
rm -f /etc/init.d/unicorn
sudo ln -s /home/ubuntu/deploy/config/unicorn_init.sh /etc/init.d/unicorn

service nginx restart
