# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :stage, 'production'

set :application, "new_teammaker"
set :repo_url, "git@github.com:Aurorawr/new-teammaker.git"

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/new_teammaker"

# Default value for :format is :airbrussh.
set :format, :pretty

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor/bundle", "public/uploads"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 3

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :rvm_type, :user
set :rvm_ruby_version, '2.7.1'
set :rvm_binary, '~/.rvm/bin/rvm'
set :rvm_bin_path, "$HOME/bin"
set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :user, 'ec2-user'
set :use_sudo, false
set :deploy_via, :copy

set :rails_env, fetch(:stage)

set :passenger_environment_variables, { :path => '/usr/lib/ruby/vendor_ruby/phusion_passenger/bin:$PATH' }
set :passenger_restart_command, '/usr/lib/ruby/vendor_ruby/phusion_passenger/bin/passenger-config restart-app'

namespace :deploy do
    desc "Make sure local git is in sync with remote"
    task :check_revision do
        on roles(:app) do
            unless `git rev-parse HEAD` == `git rev-parse origin/master`
                puts "Warning: HEAD is not the same as origin/master"
                puts "Run 'git push' to sync changes."
                exit
            end
        end
    end

    desc 'Restart app'
    task :restart do
        on roles(:app), in: :sequence, wait: 5 do
            within release_path do
                execute :bundle, 'install'
                execute :chmod, '777 ' + release_path.join('tmp/cache/').to_s
                execute :chmod, '777 ' + release_path.join('log/').to_s
                execute :rake, 'db:create RAILS_ENV=production'
                execute :rake, 'db:migrate RAILS_ENV=production'
                execute :rake, 'assets:precompile RAILS_ENV=production'
                execute 'sudo service apache2 restart'
            end
        end
    end

    before :starting, :check_revision
    before :finishing, :restart
end