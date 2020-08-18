require 'spec_helper'

# package /succeed
%w[
  curl file git ruby which texinfo bzip2-devel libcurl-devel
  expat-devel ncurses-devel zlib-devel make glibc-headers
  openssl-devel readline libyaml-devel readline-devel
  libicu-devel zlib zlib-devel libffi-devel libxml2 libxslt
  libxml2-devel libxslt-devel sqlite-devel ImageMagick
  ImageMagick-devel nginx
].each do |pkg|
  describe package(pkg), :if => os[:family] == 'amazon' do
    it { should be_installed }
  end
end

# 'Development tools'package
%w[
  autoconf automake bison	byacc cscope ctags diffstat doxygen
  flex gcc-c++ gcc-gfortran	indent intltool	libtool patch
  patchutils rcs rpm-build rpm-sign subversion swig systemtap
].each do |development_tool|
  describe package(development_tool), :if => os[:family] == 'amazon' do
    it { should be_installed }
  end
end

# npm /succeed
%w[yarn].each do |npm|
  describe package(npm) do
    let(:path) { '~/.anyenv/envs/nodenv/shims:$PATH' }
    let(:disable_sudo) { true }
    it { should be_installed.by(:npm) }
  end
end

# gem /succeed
%w[bundler rails].each do |gems|
  describe package(gems) do
    let(:path) { '~/.anyenv/envs/rbenv/shims:$PATH' }
    let(:disable_sudo) { true }
    it { should be_installed.by(:gem) }
  end
end

# port /succeed
%w[80 22].each do |port_num|
  describe port(port_num) do
    it { should be_listening }
  end
end

# service /succeed
describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

# user /succeed
describe user('ec2-user') do
  it { should exist }
  it { should belong_to_group 'ec2-user' }
end

# Check the package with a command that does not use sudo /succeed
%w[brew anyenv rbenv nodenv].each do |dis_su_pkg|
  describe command("#{dis_su_pkg} -v") do
    # let!(:sudo_options) { '-u ec2-user' }
    let(:disable_sudo) { true }
    let(:path) { '/home/linuxbrew/.linuxbrew/bin:~/.anyenv/envs/nodenv/bin:~/.anyenv/envs/rbenv/bin:$PATH' }
    its(:exit_status) { should eq 0 }
  end
end

# postgreSQL
describe command('psql -V') do
  let(:sudo_options) { '-u ec2-user' }
  its(:exit_status) { should eq 0 }
end

# exist & login by ec2-user /succeed
describe command('whoami') do
  let(:sudo_options) { '-u ec2-user' }
  its(:stdout) { should match 'ec2-user' }
  its(:exit_status) { should eq 0 }
end

# expect install ruby version (ruby x.x.x) /succeed
describe command('ruby -v') do
  let(:path) { '~/.anyenv/envs/rbenv/shims:$PATH' }
  let(:disable_sudo) { true }
  its(:stdout) { should match "ruby #{/\d\.\d\.\d/}" }
end

# file /succeed
describe file('/home/ec2-user/raise_app/tmp/unicorn.sock') do
  it { should exist }
  it { should be_socket }
end
# rbenvs plugin /succeed
describe file('/home/ec2-user/.anyenv/envs/rbenv/plugins/ruby-build') do
  it { should exist }
  it { should be_directory }
end

# /var/lib/nginx permission do ec2-user /succeed
describe file('/var/lib/nginx') do
  it { should be_owned_by 'ec2-user' }
end

# Gemfile  #{/\.\*/i} I can't Regexp but /succeed
describe file('/home/ec2-user/raise_app/Gemfile') do
  it { should exist }
end
