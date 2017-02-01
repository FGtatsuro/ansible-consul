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
