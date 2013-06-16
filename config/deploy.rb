#
# Put here shared configuration shared among all children
#
# Read more about configurations:
# https://github.com/railsware/capistrano-multiconfig/README.md

# Configuration example for layout like:
# config/deploy/{NAMESPACE}/.../#{PROJECT_NAME}/{STAGE_NAME}.rb

set :scm, :git
set :deploy_via, :remote_cache
set :branch, "production"
set :rails_env, "production" # always production!
set :default_env, "production"
set :auto_accept, 0
set :keep_releases, 5
set :user, "mconf"
set :group, "www-data"
set :use_bundle, true
set(:application) { config_name.split(':').reverse[1] }
set(:stage) { config_name.split(':').last }
set(:rake) { use_bundle ? "bundle exec rake" : "rake" }
set(:repository) { "git://github.com/mconf/#{application}.git" }
set(:deploy_to) { "/var/www/#{application}" }

default_run_options[:pty] = true # anti-tty error

after "multiconfig:ensure", "utils:info"
after "deploy:setup", "file:fix_permissions"
after "deploy:update", "deploy:cleanup"
after "deploy:update_code", "file:symlinks"
after "deploy:update_code", "file:fix_permissions"
after "deploy:finalize_update", "file:upload_config_files"
