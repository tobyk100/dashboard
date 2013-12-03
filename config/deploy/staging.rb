set :rails_env, 'staging'
#server "dash1.dev-code.org", :app, :web
#server "dash2.dev-code.org", :app, :web
server "dash3.dev-code.org", :app, :web, :db, :primary => true
