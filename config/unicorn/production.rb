app_path = "/home/agr/current"

listen "#{app_path}/tmp/sockets/unicorn.sock"
pid "#{app_path}/tmp/pids/unicorn.pid"
preload_app true
stderr_path "#{app_path}/log/unicorn.stderr.log"
stdout_path "#{app_path}/log/unicorn.stdout.log"
timeout 30
worker_processes 2
