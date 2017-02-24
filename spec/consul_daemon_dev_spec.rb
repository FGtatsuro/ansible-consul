require 'serverspec'
set :backend, :exec

# Traivs specified.
# IPAddress on Ruby: http://qiita.com/suu_g/items/a03af621f5d6985879e0
require 'socket'
private_ip = Socket.getifaddrs.select {|a| a.name == 'en0' && a.addr.ipv4?}.first.addr.ip_address

describe command("consul members -rpc-addr=#{private_ip}:8400") do
  its(:stdout) { should match /#{private_ip}:8301/ }
  its(:stdout) { should match /travis_consul/ }
  its(:stdout) { should match /server/ }
  its(:exit_status) { should eq 0 }
end

describe file('/var/log/consul/stdout.log') do
  its(:content) { should match /Consul agent running/ }
  it { should be_owned_by ENV['CONSUL_OWNER'] }
  it { should be_grouped_into ENV['CONSUL_GROUP'] }
end

describe file('/var/log/consul/stderr.log') do
  its(:size) { should eq 0 }
  it { should be_owned_by ENV['CONSUL_OWNER'] }
  it { should be_grouped_into ENV['CONSUL_GROUP'] }
end

describe file('/var/run/consul/consul.pid') do
  it { should be_file }
  it { should be_owned_by ENV['CONSUL_OWNER'] }
  it { should be_grouped_into ENV['CONSUL_GROUP'] }
end

# From a default config file
describe file('/tmp/consul/serf') do
  it { should be_directory }
  it { should be_owned_by ENV['CONSUL_OWNER'] }
  it { should be_grouped_into ENV['CONSUL_GROUP'] }
end
