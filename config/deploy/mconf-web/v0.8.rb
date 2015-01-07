# To deploy using Mconf-Web version 0.8x.

# RVM bootstrap
require "rvm/capistrano"
set :rvm_ruby_string, "1.9.2-p290@mconf"
set :rvm_type, :system

# whenever integration
set :whenever_command, "bundle exec whenever"
set :whenever_environment, "production"
require "whenever/capistrano"

set(:symlinks) do
  ["public/logos", "public/uploads", "attachments"]
end

# confirm before any action
after "utils:info", "utils:confirm"

set :branch, "v0.8.1"
set :server, "192.168.0.1"
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :git_enable_submodules, 1
# set(:repository) { "git://github.com/my-fork/mconf-web.git" }

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

before "deploy:setup", "rvm:install_ruby"
after "deploy:setup", "rvm:trust_rvmrc"
after "deploy:update_code", "rvm:trust_rvmrc"
