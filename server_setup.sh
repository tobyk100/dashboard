#!/bin/bash

set -e

export DASH_ROOT=$1
if [[ -z $DASH_ROOT ]]; then
  export DASH_ROOT=/home/ubuntu/deploy
fi

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

bundle install --gemfile=$DASH_ROOT/Gemfile --binstubs

rm -f /etc/nginx/sites-enabled/default
nginx_cfg=/etc/nginx/sites-enabled/dashboard
if [[ ! -e $nginx_cfg ]]; then
  sudo ln -s $DASH_ROOT/config/nginx.conf $nginx_cfg
fi

unicorn_cfg=/etc/init.d/unicorn
rm -f $unicorn_cfg
if [[ ! -e $unicorn_cfg ]]; then
  sudo ln -s $DASH_ROOT/config/unicorn_init.sh $unicorn_cfg
fi

service nginx restart
