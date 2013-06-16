ROOT_PATH = File.join(File.expand_path(File.dirname(__FILE__)), "..")

namespace :file do

  # Scans `config_files/:application/:stage` and uploads any file found
  # to the server using the same file tree used inside the local tree.
  # Example:
  #  config_files/mconf-web/staging/config/some/file.yml ->
  #    <release_path>/config/some/file.yml
  desc "Send to the server the local configuration files (if any)"
  task :upload_config_files do
    basepath = File.join(ROOT_PATH, "config_files", application, stage)
    Dir.glob("#{basepath}/**/*") do |path|
      unless File.directory?(path)
        target = File.join(latest_release, path.gsub(basepath, ""))
        top.upload path, target, :via => :scp
      end
    end
  end

  desc "Refresh shared symlinks to current path"
  task :symlinks, :roles => :app do
    fetch(:symlinks).each do |target|
      run "rm -rf #{latest_release}/#{target}; true"
      run "ln -sT #{shared_path}/#{target} #{latest_release}/#{target}"
    end
  end

  desc "Fix permissions in the application's directory tree"
  task :fix_permissions, :roles => :app do
    run "#{try_sudo} chown -R #{user}:#{group} #{deploy_to}"
  end

end
