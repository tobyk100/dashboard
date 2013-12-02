set :rails_env, 'staging'
server "dash1.dev-code.org", :app, :web, :db, :primary => true
server "dash2.dev-code.org", :app, :web
