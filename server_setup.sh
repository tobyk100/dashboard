#!/bin/bash

set -e

if [[ $1 = "-d" ]]; then
  echo "DEV MODE"
  export CDO_DEV=true
  shift
fi

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
  libssl-dev \
  mysql-server \
  libmysqlclient-dev \
  nginx

if [[ ! -f ruby-2.0.0-p247.tar.gz ]]; then
  wget http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.gz
  tar -xzvf ruby-2.0.0-p247.tar.gz
  (
    cd ruby-2.0.0-p247/
    ./configure
    make
    sudo make install
  )
fi

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

if $CDO_DEV; then
  locale-gen en_IE en_IE.UTF-8 en_US.UTF-8
  dpkg-reconfigure locales
  aptitude -y install default-jre-headless
  su -c "/vagrant/dev_setup.sh" vagrant
fi
