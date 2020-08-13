require 'serverspec'
require 'net/ssh'

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)

options[:user] ||= Etc.getlogin

set :host,        options[:host_name] || host
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true

# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
set :path, '/sbin:/usr/local/sbin:
  /home/ec2-user.anyenv/envs/nodenv/versions/12.18.3/bin:
  /home/ec2-user/.anyenv/envs/rbenv/shims:
  /home/ec2-user/.anyenv/envs/rbenv/bin/rbenv:
  /home/ec2-user/.anyenv/envs/rbenv/bin:
  /home/ec2-user/.anyenv/envs/nodenv/shims/npm:
  /home/ec2-user/.anyenv/envs/nodenv/shims/yarn:
  /home/ec2-user/.anyenv/envs/nodenv/shims:
  /home/ec2-user/.anyenv/envs/nodenv/bin:
  /home/ec2-user/.anyenv/envs/nodenv/bin/nodenv:
  /home/linuxbrew/.linuxbrew/bin/anyenv:
  /home/linuxbrew/.linuxbrew/bin:
  /home/linuxbrew/.linuxbrew/sbin:
  /usr/local/bin:
  /usr/bin:
  /usr/local/sbin:
  /usr/sbin:
  /home/ec2-user/.local/bin:
  /home/ec2-user/bin
  $PATH'
