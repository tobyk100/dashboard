listen 3000 # by default Unicorn listens on port 8080
listen "/tmp/unicorn.dashboard.sock"
worker_processes 2 # this should be >= nr_cpus
pid "/home/ubuntu/apps/dashboard/shared/pids/unicorn.pid"
timeout 60
stderr_path "/var/log/unicorn/stderr.log"
stdout_path "/var/log/unicorn/stdout.log"
working_directory "/home/ubuntu/apps/dashboard/current"
