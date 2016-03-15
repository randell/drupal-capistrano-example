# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'drupal7-demo'
set :repo_url, 'git@bitbucket.org:adelphidigital/drupal7-demo.git'
set :app_path, 'app'

# Link file settings.php
set :linked_files, fetch(:linked_files, []).push('app/sites/default/settings.php')

# Link dirs files and private-files
set :linked_dirs, fetch(:linked_dirs, []).push('app/sites/default/files', 'private-files')

# Remove default composer install task on deploy:updated
Rake::Task['deploy:updated'].prerequisites.delete('composer:install')

# Map composer and drush commands
# NOTE: If stage have different deploy_to
# you have to copy those line for each <stage_name>.rb
# See https://github.com/capistrano/composer/issues/22
SSHKit.config.command_map[:composer] = "#{shared_path.join("composer.phar")}"
SSHKit.config.command_map[:drush] = "#{shared_path.join("vendor/bin/drush")}"

# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server '198.58.113.142', user: 'randell', roles: %w{app db web}, my_property: :my_value
set :home, '/home/randell'
set :tmp_dir, "#{fetch(:home)}/tmp"

# overwrite deploy_to
set :deploy_to, '/srv/www/drupal7-demo/public_html/'

# set a branch for this release
set :branch, 'master'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
