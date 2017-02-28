require "spec_helper_#{ENV['SPEC_TARGET_BACKEND']}"

# Output example
# Node       Address            Status  Type    Build  Protocol  DC
# vm_server  192.168.50.2:8301  alive   server  0.7.5  2         dc1
# vm_client  192.168.50.3:8301  alive   client  0.7.5  2         dc1
describe command("consul members -rpc-addr=#{ENV['CONSUL_CLIENT_ADDR']}:8400") do
  # Specified settings in Rakefile
  its(:stdout) { should match /vm_server\s*192.168.50.2:8301\s*alive\s*server/ }
  its(:stdout) { should match /vm_client\s*192.168.50.3:8301\s*alive\s*client/ }
  its(:exit_status) { should eq 0 }
end

# Specified settings(DNS port=53) in Rakefile
describe command("dig @#{ENV['CONSUL_CLIENT_ADDR']} vm_server.node.consul") do
  its(:stdout) { should match /192.168.50.2/ }
  its(:exit_status) { should eq 0 }
end

describe command("dig @#{ENV['CONSUL_CLIENT_ADDR']} vm_client.node.consul") do
  its(:stdout) { should match /192.168.50.3/ }
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

describe file('/tmp/consul') do
  it { should be_directory }
  it { should be_owned_by ENV['CONSUL_OWNER'] }
  it { should be_grouped_into ENV['CONSUL_GROUP'] }
end


