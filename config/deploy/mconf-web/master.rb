# confirm before any action
after "utils:info", "utils:confirm"

set :branch, "master"
set :server, "192.168.0.1"
# set(:repository) { "git://github.com/my-fork/mconf-web.git" }

role :app, fetch(:server)
role :web, fetch(:server)
role :db, fetch(:server), :primary => true
