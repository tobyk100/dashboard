set :rails_env, 'staging'
server "dash5.dev-code.org", :app, :web, :db, :primary => true
server "dash6.dev-code.org", :app, :web
server "dash7.dev-code.org", :app, :web
