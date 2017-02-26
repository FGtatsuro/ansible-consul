require 'rake'
require 'rspec/core/rake_task'

task :spec    => 'spec:all'
task :default => :spec

namespace :spec do
  hosts = [
    {
      :name     =>  'localhost',
      :backend  =>  'exec',
      :consul_config_remote_dir =>  '/Users/travis/consul.d',
      :consul_owner  =>  'travis',
      :consul_group  =>  'staff',
      :consul_node_name =>  'travis_consul',
      :has_consul_addr  =>  'true',
      :consul_dns_port  =>  '53',
      :pattern  =>  'spec/consul_spec.rb,spec/consul_daemon_dev_spec.rb'
    },
    {
      :name     =>  'container',
      :backend  =>  'docker',
      :consul_config_remote_dir =>  '/etc/consul.d',
      :consul_owner  =>  'consul',
      :consul_group  =>  'consul',
      :pattern  =>  'spec/consul_spec.rb'
    }
  ]
  if ENV['SPEC_TARGET'] then
    target = hosts.select{|h|  h[:name] == ENV['SPEC_TARGET']}
    hosts = target unless target.empty?
  end

  task :all     => hosts.map{|h|  "spec:#{h[:name]}"}
  task :default => :all

  hosts.each do |host|
    desc "Run serverspec tests to #{host[:name]}(backend=#{host[:backend]})"
    RSpec::Core::RakeTask.new(host[:name].to_sym) do |t|
      ENV['TARGET_HOST'] = host[:name]
      ENV['SPEC_TARGET_BACKEND'] = host[:backend]
      ENV['CONSUL_CONFIG_REMOTE_DIR'] = host[:consul_config_remote_dir]
      ENV['CONSUL_OWNER'] = host[:consul_owner]
      ENV['CONSUL_GROUP'] = host[:consul_group]
      ENV['CONSUL_NODE_NAME'] = host[:consul_node_name]
      ENV['HAS_CONSUL_ADDR'] = host[:has_consul_addr]
      ENV['CONSUL_DNS_PORT'] = host[:consul_dns_port]
      t.pattern = host[:pattern]
    end
  end
end
