lock '3.4.0'

hosts = DescribeInstances.new.each.to_a
set :hosts, hosts

set :application, 'picmrk.com'
set :repo_url, 'https://github.com/ksss/picmrk.com.git'
set :deploy_to, "/var/picmrk.com"
set :format, :pretty
set :log_level, :debug
set :normalize_asset_timestamps, false
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

namespace :deploy do
  desc "Start application"
  task :start do
    invoke 'unicorn:start'
  end

  desc "Stop application"
  task :stop do
    invoke 'unicorn:stop'
  end

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  after :publishing, :restart
  before :updated, 'secrets:upload_secret_files'
end
