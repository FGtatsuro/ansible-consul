require 'serverspec'
set :backend, :exec

# Traivs specified.
# IPAddress on Ruby: http://qiita.com/suu_g/items/a03af621f5d6985879e0
require 'socket'
private_ip = Socket.getifaddrs.select {|a| a.name == 'en0' && a.addr.ipv4?}.first.addr.ip_address

describe command("consul members -rpc-addr=#{private_ip}:8400") do
  its(:stdout) { should match /#{private_ip}:8301/ }
  its(:stdout) { should match /travis/ }
  its(:stdout) { should match /server/ }
  its(:exit_status) { should eq 0 }
end
