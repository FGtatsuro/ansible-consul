require "spec_helper_#{ENV['SPEC_TARGET_BACKEND']}"

describe command('consul version') do
  its(:exit_status) { should eq 0 }
end

describe command('consul version'), :if => ['alpine', 'debian'].include?(os[:family]) do
  its(:stdout) { should contain("Consul v0.7.5") }
end

describe file('/usr/local/bin/consul') do
  it { should be_executable }
end

# Default settings
[
  '/opt/consul/daemons.py',
  '/opt/consul/services.sh'
].each do |f|
  describe file(f) do
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by ENV['CONSUL_OWNER'] }
    it { should be_grouped_into ENV['CONSUL_GROUP'] }
  end
end
describe file('/opt/consul/daemons.py') do
  its(:content) { should match /\/opt\/consul\/services\.sh/ }
  its(:content) { should match /\/var\/log\/consul\/stdout\.log/ }
  its(:content) { should match /\/var\/log\/consul\/stderr\.log/ }
  its(:content) { should match /\/var\/run\/consul\.pid/ }
end

describe package('python-daemon') do
  it { should be_installed.by(:pip) }
end

describe file('/var/log/consul') do
  it { should be_directory }
  it { should be_owned_by ENV['CONSUL_OWNER'] }
  it { should be_grouped_into ENV['CONSUL_GROUP'] }
end

# Last '/' is needed. For example,  in Ubuntu:
#
# $ ls -altd /var/run
# lrwxrwxrwx 1 root root 4 Mar 26  2015 /var/run -> /run
# $ ls -altd /var/run/
# drwxr-xr-x 20 root root 840 Feb 22 18:11 /var/run/
describe file('/var/run/') do
  it { should exist }
  it { should be_mode ENV['LOCK_MODE'] }
  it { should be_owned_by 'root' }
  it { should be_grouped_into ENV['LOCK_GROUP'] }
end

# Custom settings
[
  "#{ENV['CONSUL_CONFIG_REMOTE_DIR']}/web.json",
  "#{ENV['CONSUL_CONFIG_REMOTE_DIR']}/db.json"
].each do |f|
  describe file(f) do
    it { should be_file }
    it { should be_readable }
    it { should be_owned_by ENV['CONSUL_OWNER'] }
    it { should be_grouped_into ENV['CONSUL_GROUP'] }
  end
end
