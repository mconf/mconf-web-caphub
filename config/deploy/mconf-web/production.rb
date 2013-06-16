# confirm before any action
after "utils:info", "utils:confirm"

set :branch, "latest"
set :server, "my-server.domain.com"
set :rvm_ruby_string, "1.9.2-p290@mconf"
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :git_enable_submodules, 1

# no assets in this version of rails
namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
    end
  end
end

role :app, fetch(:server)
role :web, fetch(:server)
role :db, fetch(:server), :primary => true
