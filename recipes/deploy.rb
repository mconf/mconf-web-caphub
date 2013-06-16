namespace :deploy do

  # Passenger tasks
  task(:start) {}
  task(:stop) {}
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_release, 'tmp', 'restart.txt')}"
  end

end
