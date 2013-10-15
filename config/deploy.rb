require 'bundler/capistrano'

set :application, "dashboard"
set :user, "ubuntu"
set :stages, ["staging", "production"]
#set :default_stage, "staging"

set :scm, "git"
set :branch, "master"
set :repository,  "git@github.com:code-dot-org/dashboard.git"
#set :git_enable_submodules, 1

set :keep_releases, 10
set :deploy_to, "/home/#{user}/apps/#{application}"

require 'capistrano/ext/multistage'

#server "dashboard.dev-code.org", :app, :web, :db, :primary => true
#set :domain, "dashboard.dev-code.org"
#role :web, domain                          # Your HTTP server, Apache/etc
#role :app, domain                          # This may be the same as your `Web` server


namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn #{command}"
    end
  end

  task :post_deploy do
    rake = fetch(:rake, 'rake')
    rails_env = fetch(:rails_env, 'development')

    run "cd '#{current_path}' && #{rake} blockly:latest RAILS_ENV=#{rails_env} && #{rake} youtube:thumbnails RAILS_ENV=#{rails_env}"
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn"
    run "mkdir -p #{shared_path}/config"
    #put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
  after "deploy", "deploy:post_deploy"
end

require './config/boot'
require 'honeybadger/capistrano'
