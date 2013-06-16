# RVM bootstrap
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.3-p194@mconf'
set :rvm_type, :system

# bundler bootstrap
require 'bundler/capistrano'

# assets
load "deploy/assets"

# whenever integration
set :whenever_command, "bundle exec whenever"
set :whenever_environment, "production"
require "whenever/capistrano"

set(:symlinks) do
  ["public/logos", "attachments"] # public/scorm, public/pdf
end

namespace :deploy do
  task :local_fix_permissions, :roles => :app do
    run "if [ -d \"#{shared_path}/attachments\" ]; then #{try_sudo} chmod -R g+w #{shared_path}/attachments; fi"
    run "if [ -d \"#{shared_path}/public/logos\" ]; then #{try_sudo} chmod -R g+w #{shared_path}/public/logos; fi"
  end
end

namespace :setup do

  desc "Setup a server for the first time"
  task :basic do
    setup.db              # destroys and recreates the DB
    setup.secret          # new secret
    # setup.statistics      # start google analytics statistics
  end

  desc "recreates the DB and populates it with the basic data"
  task :db do
    run "cd #{current_release} && bundle exec rake db:reset RAILS_ENV=production"
  end

  # User uploaded files are stored in the shared folder
  task :create_shared do
    run "#{try_sudo} mkdir -p #{shared_path}/attachments"
    run "#{try_sudo} mkdir -p #{shared_path}/public/logos"
  end

  desc "Creates a new secret in config/initializers/secret_token.rb"
  task :secret do
    run "cd #{current_release} && bundle exec rake setup:secret RAILS_ENV=production"
    puts "You must restart the server to enable the new secret"
  end

  desc "Creates the Statistic table - needs config/analytics_conf.yml"
  task :statistics do
    run "cd #{current_release} && bundle exec rake statistics:init RAILS_ENV=production"
  end
end

namespace :db do
  task :pull do
    run "cd #{current_release} && RAILS_ENV=production bundle exec rake db:data:dump"
    download "#{current_release}/db/data.yml", "db/data.yml"
    `bundle exec rake db:reset db:data:load`
  end

  # Gets usage statistics and outputs to a local `stats.txt` file
  task :stats do
    run "cd #{current_release} && RAILS_ENV=production bundle exec rake mconf:stats OUTPUT=stats.txt"
    download "#{current_release}/stats.txt", "stats.txt"
    run "rm #{current_release}/stats.txt"
  end
end

before "deploy:setup", "rvm:install_ruby"
after "deploy:setup", "setup:create_shared"
after "deploy:setup", "rvm:trust_rvmrc"
after "deploy:update_code", "rvm:trust_rvmrc"
after "file:fix_permissions", "deploy:local_fix_permissions"
after "setup:create_shared", "deploy:local_fix_permissions"
