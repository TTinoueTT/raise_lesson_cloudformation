require 'spec_helper'

# package
%w{
  curl file git ruby which texinfo bzip2-devel curl-devel 
  expat-devel ncurses-devel zlib-devel make glibc-headers 
  openssl-devel readline libyaml-devel readline-devel 
  libicu-devel zlib zlib-devel libffi-devel libxml2 libxslt 
  libxml2-devel libxslt-devel sqlite-devel ImageMagick 
  ImageMagick-devel libxcrypt-compat nginx
}.each do |pkg|
  describe package(pkg), :if => os[:family] == 'amazon' do
    it { should be_installed }
  end
end

# port
%W{80 22}.each do |port_num|
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
end


# gitでcloneしたパッケージは反応しない
# describe package('rbenv') do
#   it { should be_installed }
# end

# describe package("rbenv-#{'ruby-build'}") do
#   it { should be_installed }
# end

# describe package('ruby') do
#   # let(:path) { '/usr/local/rbenv/shims/ruby' }
#   it { should be_installed }
# end

# コマンドでRuby x.x.x のインストール確認
describe command('ruby -v') do
  its(:stdout) { should match /ruby \d\.\d\.\d/ }
end

# コマンドでyarn x.x.x のインストール確認
describe command('yarn -v') do
  its(:stdout) { should match /yarn \d\.\d\d\.\d/ }
end


# Severspec v2 で廃止の書き方
# describe command('ruby -v') do
#   it { should return_stdout /ruby 2\.7\.1/ }
# end

# rbenvの存在確認
%W{
  /usr/local/rbenv
  /usr/local/rbenv/plugins/ruby-build
}.each do |ruby_relational_file|
  describe file(ruby_relational_file) do
    it { should exist }
  end
end

# ユーザの存在確認
describe user('ec2-user') do
  it { should belong_to_group 'ec2-user' }
end

# gemでインストールされたパッケージ群
# ここで gem install rails が通っていればrails導入の確認が出来た
# bundleとはいえ一応gemsにパッケージは入っている
%w{bundler}.each do |gems|
  describe package(gems) do
    it { should be_installed.by(:gem) }
  end
end

# railsコマンドから確認、カレントディレクトリがアプリのある階層じゃないとはまらない 
describe command('bundle exec rails -v') do
  its(:stdout) { should match /Rails \d\.\d\.\d\.\d/ }
end

# リンクの部分を正規表現で記述することがわからない↓通らず
describe file("~/vendor/bundle/ruby/2.7.0/gems/rails-#{ \d\.\d\.\d\.\d }") do
  it { shoud exist } 
end

# gemsディレクトリの中にrailsのgemディレクトリがあると言いたい
describe file('~/vendor/bundle/ruby/2.7.0/gems') do
  its(:content) { should match /rails-\d\.\d\.\d\.\d/ }
end



