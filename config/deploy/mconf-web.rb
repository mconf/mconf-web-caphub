# The configurations here default to the latest version of Mconf-Web/Rails we use.
# Specific configurations for older releases are done in the configuration files related
# to these releases (e.g. `./mconf-web/staging.rb`)

# When setting up a new server:
#   cap mconf-web:staging deploy:setup
#   cap mconf-web:staging deploy:update
#   cap mconf-web:staging deploy:secret
#   cap mconf-web:staging deploy:db:reset
#   cap mconf-web:staging deploy:migrations
#   cap mconf-web:staging deploy:restart

# bundler bootstrap
require 'bundler/capistrano'

# assets
load "deploy/assets"

set(:symlinks) do
  ["public/logos", "public/uploads", "private/uploads", "attachments"]
end

# for rbenv, otherwise bundler (and maybe other gems) won't be found
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

namespace :deploy do
  task :local_fix_permissions, :roles => :app do
    run "if [ -d \"#{shared_path}/attachments\" ]; then #{try_sudo} chmod -R g+w #{shared_path}/attachments; fi"
    run "if [ -d \"#{shared_path}/public/logos\" ]; then #{try_sudo} chmod -R g+w #{shared_path}/public/logos; fi"
    run "if [ -d \"#{shared_path}/public/uploads\" ]; then #{try_sudo} chmod -R g+w #{shared_path}/public/uploads; fi"
    run "if [ -d \"#{shared_path}/private/uploads\" ]; then #{try_sudo} chmod -R g+w #{shared_path}/private/uploads; fi"
  end

  task :fix_manifest, :roles => :app do
    run "touch \"#{shared_path}/assets/manifest.yml\""
  end

  desc "Creates a new secret in config/initializers/secret_token.rb"
  task :secret do
    sed = "sed -i \"s/secret_token =.*/secret_token = '`RAILS_ENV=production bundle exec rake secret`'/g\" ./config/initializers/secret_token.rb"
    run "cd #{current_release} && #{sed}"
  end

  namespace :db do
    desc "recreates the DB and populates it with the basic data"
    task :reset do
      run "cd #{current_release} && bundle exec rake db:create RAILS_ENV=production"
      run "cd #{current_release} && bundle exec rake db:reset RAILS_ENV=production"
    end
  end

  # User uploaded files are stored in the shared folder
  task :create_shared do
    run "#{try_sudo} mkdir -p #{shared_path}/attachments"
    run "#{try_sudo} mkdir -p #{shared_path}/public/logos"
    run "#{try_sudo} mkdir -p #{shared_path}/public/uploads"
    run "#{try_sudo} mkdir -p #{shared_path}/private/uploads"
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

# TODO: temporary, capistrano 3 might solve this
#   fixes manifest.yml not being found
before "deploy:assets:precompile", "deploy:fix_manifest"

after "deploy:setup", "deploy:create_shared"
after "deploy:finalize_update", "file:upload_config_files"
after "file:fix_permissions", "deploy:local_fix_permissions"
after "deploy:create_shared", "deploy:local_fix_permissions"
