set :branch, "branch-v2"
set :server, "my-server.domain.com"

role :app, fetch(:server)
role :web, fetch(:server)
role :db, fetch(:server), :primary => true
