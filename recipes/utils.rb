namespace :utils do

  desc "Prints information about the current deployment configuration"
  task :info do
    puts
    puts "\n\e[0;34m"
    puts "   *******************************************************"
    puts "          stage: #{stage.upcase}"
    puts "         server: #{fetch(:server)}"
    puts "         branch: #{fetch(:branch)}"
    puts "     repository: #{fetch(:repository)}"
    puts "    application: #{fetch(:application)}"
    puts "     user:group: #{user}:#{group}"
    puts "   *******************************************************"
    puts "\e[0m\n"
    puts
  end

  # Prompt to make really sure we want to deploy into production
  # By http://www.pastbedti.me/2009/01/handling-a-staging-environment-with-capistrano-rails/
  desc "Confirm if the deployment should proceed"
  task :confirm do
    puts "\n\e[0;31m"
    puts "   ######################################################################"
    puts "          Are you REALLY sure you want to deploy to #{stage.upcase} ?"
    puts "           Enter [y/Y] to continue or anything else to cancel"
    puts "   ######################################################################"
    puts "\e[0m\n"
    if fetch(:auto_accept) == 0
      proceed = STDIN.gets[0..0] rescue nil
      unless proceed == 'y' || proceed == 'Y'
        puts "Aborting..."
        exit
      end
    end
  end

end
