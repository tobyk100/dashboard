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

export CDO_USER=$2
if [[ -z $CDO_DEV ]]; then
  export CDO_USER=ubuntu
fi

export DEBIAN_FRONTEND=noninteractive
aptitude update

# Production service dependencies.
aptitude -y install \
  build-essential \
  git \
  mysql-client \
  libssl-dev \
  mysql-server \
  libmysqlclient-dev \
  nginx

# Native dependencies for builds with Node.js.
if $CDO_DEV; then
  aptitude -y install \
    libcairo2-dev \
    libjpeg8-dev \
    libpango1.0-dev \
    libgif-dev \
    g++
fi

export CDO_BUILD_PATH=/usr/src

if [[ ! -f $CDO_BUILD_PATH/ruby-2.0.0-p247.tar.gz ]]; then
  wget -P $CDO_BUILD_PATH http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.gz
  tar -C $CDO_BUILD_PATH -xzvf $CDO_BUILD_PATH/ruby-2.0.0-p247.tar.gz
  (
    cd $CDO_BUILD_PATH/ruby-2.0.0-p247
    ./configure
    make
    make install
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

  if [[ ! -d $CDO_BUILD_PATH/node-0.10.20 ]]; then
    wget -P $CDO_BUILD_PATH https://github.com/joyent/node/archive/v0.10.20.tar.gz
    tar -C $CDO_BUILD_PATH -xzvf $CDO_BUILD_PATH/v0.10.20.tar.gz
    (
      cd $CDO_BUILD_PATH/node-0.10.20
      ./configure
      make
      make install
    )
  fi

  npm install -g grunt-cli

  su -c $DASH_ROOT/dev_setup.sh $CDO_USER
fi
