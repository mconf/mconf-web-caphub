namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "if [ -d #{latest_release} ]; then rvm rvmrc trust #{latest_release}; fi"
    run "if [ -d #{current_path} ]; then rvm rvmrc trust #{current_path}; fi"
  end
end
