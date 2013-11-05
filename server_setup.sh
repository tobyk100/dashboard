#!/bin/bash

set -e

# Parse option flags.
if [[ $1 = "-d" ]]; then
  echo "DEV MODE"
  export CDO_DEV=1
  export RAILS_ENV=development
  shift
else
  export RAILS_ENV=production
fi

# Parse positional arguments.
if [[ $# -lt 2 ]]; then
  echo 'Usage: server_setup.sh [options] <dash_root> <cdo_user>'
  exit 1
fi
export DASH_ROOT=$1
export CDO_USER=$2

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
if [[ $CDO_DEV ]]; then
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

# Configure Unicorn
unicorn_cfg=/etc/init.d/unicorn
rm -f $unicorn_cfg
sed -e "s|%DASH_ROOT%|$DASH_ROOT|g" \
    -e "s|%CDO_USER%|$CDO_USER|g" \
    -e "s|%RAILS_ENV%|$RAILS_ENV|g" \
    $DASH_ROOT/config/unicorn_init.sh > $unicorn_cfg
chmod +x $unicorn_cfg
$DASH_ROOT/config/unicorn.rb.sh > $DASH_ROOT/config/unicorn.rb
mkdir -p /var/log/unicorn
chown $CDO_USER /var/log/unicorn

# Configure Nginx
nginx_cfg=/etc/nginx/nginx.conf
site_cfg=/etc/nginx/sites-enabled/dashboard
rm -f /etc/nginx/sites-enabled/default $nginx_cfg $site_cfg
cp $DASH_ROOT/config/nginx.conf $nginx_cfg
$DASH_ROOT/config/nginx-site.sh > $site_cfg
service nginx restart

# Configure Node.js
if [[ $CDO_DEV ]]; then
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
