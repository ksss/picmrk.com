set :rbenv_type, :user
set :rbenv_ruby, '2.3.0-dev'
set :unicorn_rack_env, "production"

hosts = fetch(:hosts).select{ |h|
  h.name == 'picmrk.com-prd'
}

ips = hosts.map(&:public_ip_address)
role :app, ips
role :web, ips
role :db,  ips

set :ssh_options, {
  user: 'deploy',
  keys: hosts.map{ |h|
    File.expand_path("~/.ssh/aws/#{h.key_name}.pem")
  }.uniq,
#  forward_agent: false,
#  auth_methods: %w(password)
}
