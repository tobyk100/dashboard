#!/bin/bash

cat <<EOF
listen 3000 # by default Unicorn listens on port 8080
listen "/tmp/unicorn.dashboard.sock", backlog: 8192
worker_processes 32 # this should be >= nr_cpus
pid "${DASH_ROOT}/tmp/pids/unicorn.pid"
timeout 60
stderr_path "/var/log/unicorn/stderr.log"
stdout_path "/var/log/unicorn/stdout.log"
working_directory "${DASH_ROOT}"
EOF
