# Can't use :rake, it conflicts with the variable 'rake' used in
# several standard tasks (e.g. assets:precompile).
namespace :rake_exec do

  # Adapted from: http://stackoverflow.com/questions/312214/how-do-i-run-a-rake-task-from-capistrano
  # example: cap staging rake_exec:invoke TASK=jobs:queued
  desc "Run a task on a remote server."
  task :invoke do
    run("cd #{deploy_to}/current; bundle exec rake #{ENV['TASK']} RAILS_ENV=production")
  end
end
