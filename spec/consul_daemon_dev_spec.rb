require 'serverspec'
set :backend, :exec

describe command("consul members -rpc-addr=#{ENV['CONSUL_BIND_ADDR']}:8400") do
  its(:stdout) { should match /#{ENV['CONSUL_BIND_ADDR']}:8301/ }
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
