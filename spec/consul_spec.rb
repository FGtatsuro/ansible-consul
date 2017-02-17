require "spec_helper_#{ENV['SPEC_TARGET_BACKEND']}"

describe command('consul version') do
  its(:exit_status) { should eq 0 }
end

describe command('consul version'), :if => ['alpine', 'debian'].include?(os[:family]) do
  its(:stdout) { should contain("Consul v0.7.3") }
end

describe file('/usr/local/bin/consul') do
  it { should be_executable }
end

# Default settings
[
  '/opt/consul/daemon.py',
  '/opt/consul/services.sh'
].each do |f|
  describe file(f) do
    it { should be_mode 755 }
    it { should be_owned_by ENV['CONSUL_CONFIG_OWNER'] }
    it { should be_grouped_into ENV['CONSUL_CONFIG_GROUP'] }
  end
end
describe file('/opt/consul/daemon.py') do
  its(:content) { should match /\/opt\/consul\/services\.sh/ }
  its(:content) { should match /\/var\/log\/consul\/stdout\.log/ }
  its(:content) { should match /\/var\/log\/consul\/stderr\.log/ }
  its(:content) { should match /\/var\/lock\/consul\.pid/ }
  it { should be_executable }
  it { should be_owned_by ENV['CONSUL_CONFIG_OWNER'] }
  it { should be_grouped_into ENV['CONSUL_CONFIG_GROUP'] }
end

describe package('python-daemon') do
  it { should be_installed.by(:pip) }
end

[
  '/var/log/consul',
  '/var/lock'
].each do |f|
  describe file(f) do
    it { should exist }
    it { should be_owned_by ENV['CONSUL_CONFIG_OWNER'] }
    it { should be_grouped_into ENV['CONSUL_CONFIG_GROUP'] }
  end
end

# Custom settings
[
  "#{ENV['CONSUL_CONFIG_REMOTE_DIR']}/web.json",
  "#{ENV['CONSUL_CONFIG_REMOTE_DIR']}/db.json"
].each do |f|
  describe file(f) do
    it { should be_file }
    it { should be_readable }
    it { should be_owned_by ENV['CONSUL_CONFIG_OWNER'] }
    it { should be_grouped_into ENV['CONSUL_CONFIG_GROUP'] }
  end
end
