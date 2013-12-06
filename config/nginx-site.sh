#!/bin/bash

cat <<EOF
upstream unicorn {
  server unix:/tmp/unicorn.dashboard.sock fail_timeout=0;
}

server {
  listen 80 default deferred;
  # server_name example.com;

  location /nginx_status {
    stub_status on;
    access_log off;
    break;
  }

  root ${DASH_ROOT}/public;
  try_files \$uri/index.html \$uri @unicorn;

  location ~ /blockly/* {
    add_header 'Access-Control-Allow-Origin' '*';
    add_header 'Access-Control-Allow-Credentials' 'true';
    add_header 'Access-Control-Allow-Methods' 'GET';
    add_header 'Access-Control-Allow-Headers' 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type';
  }

  location @unicorn {
EOF

if [[ $RAILS_ENV = 'production' ]]; then
cat <<EOF
    # http://www.oneminuteinfo.com/2011/05/nginx-rewrite-test-multiple-conditions.html
    if (\$host != "learn.code.org") {
      set \$test A;
    }
    if (\$uri !~ ^/health_check ) {
      set \$test "\${test}B";
    }
    if (\$test = AB) {
      rewrite /?(.*) http://learn.code.org/\$1 permanent;
    }
EOF
fi

cat <<EOF
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header Host \$http_host;
    proxy_redirect off;
    proxy_pass http://unicorn;
  }

  error_page 500 502 503 504 /500.html;
  client_max_body_size 4G;
  keepalive_timeout 10;
}
EOF
