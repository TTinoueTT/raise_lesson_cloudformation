require 'spec_helper'

# package
%w[
  curl file git ruby which texinfo bzip2-devel curl-devel
  expat-devel ncurses-devel zlib-devel make glibc-headers
  openssl-devel readline libyaml-devel readline-devel
  libicu-devel zlib zlib-devel libffi-devel libxml2 libxslt
  libxml2-devel libxslt-devel sqlite-devel ImageMagick
  ImageMagick-devel libxcrypt-compat nginx
].each do |pkg|
  describe package(pkg), :if => os[:family] == 'amazon' do
    it { should be_installed }
  end
end

# npm
%w[yarn].each do |npm|
  describe package(npm) do
    let(:disable_sudo) { true }
    it { should be_installed.by(:npm) }
  end
end

# gem
%w[bundler rails].each do |gems|
  describe package(gems) do
    let(:disable_sudo) { true }
    it { should be_installed.by(:gem) }
  end
end

# port
%w[80 22].each do |port_num|
  describe port(port_num) do
    it { should be_listening }
  end
end

# service
describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

# user
describe user('ec2-user') do
  it { should exist }
  it { should belong_to_group 'ec2-user' }
end

# Check the package with a command that does not use sudo
%w[anyenv rbenv nodenv yarn npm].each do |dis_su_pkg|
  describe command("#{dis_su_pkg} -v") do
    # let(:shell) { '/bin/bash' }
    let(:sudo_options) { '-u ec2-user' }
    # let(:path) { '/usr/lib64/fluent/ruby/bin:$PATH' }
    # let(:pre_command) { 'cd /home/ec2-user/' }
    # let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
  end
end

describe command('psql -V') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
end

describe command('whoami') do
  let(:sudo_options) { '-u ec2-user' }
  its(:stdout) { should match 'ec2-user' }
end

# Amazonlinux alreadey install ruby
# for error
describe command('ruby -v') do
  let(:shell) { '/bin/bash' }
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 1 }
end

# file
# %w[

# ].each do |port_num|
describe file('/home/ec2-user/raise_app/tmp/unicorn.sock') do
  it { should exist }
end

describe file('/var/lib/nginx') do
  it { should be_owned_by 'ec2-user' }
end

# describe file('/*') do
#   it { should exist }
# end
