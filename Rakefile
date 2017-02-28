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
      :consul_dns_port  =>  '9000',
      :consul_bind_interface  =>  'en0',
      :pattern  =>  'spec/consul_spec.rb,spec/consul_daemon_dev_spec.rb'
    },
    {
      :name     =>  'container',
      :backend  =>  'docker',
      :consul_config_remote_dir =>  '/etc/consul.d',
      :consul_owner  =>  'consul',
      :consul_group  =>  'consul',
      :pattern  =>  'spec/consul_spec.rb'
    },
    {
      :name =>  'server',
      :backend  =>  'vagrant',
      :consul_config_remote_dir =>  '/etc/consul.d',
      :consul_owner  =>  'consul',
      :consul_group  =>  'consul',
      :consul_node_name =>  'vm_server',
      :consul_bind_addr =>  '192.168.50.2',
      :consul_client_addr =>  '192.168.50.2',
      :consul_dns_port  =>  '53',
      :consul_bootstrap_expect  =>  '1',
      :consul_server  =>  'true',
      :pattern  =>  'spec/consul_spec.rb,spec/consul_daemon_cluster_spec.rb'
    },
    {
      :name =>  'client',
      :backend  =>  'vagrant',
      :consul_config_remote_dir =>  '/etc/consul.d',
      :consul_owner  =>  'consul',
      :consul_group  =>  'consul',
      :consul_node_name =>  'vm_client',
      :consul_bind_addr =>  '192.168.50.3',
      :consul_client_addr =>  '192.168.50.3',
      :consul_dns_port  =>  '53',
      :consul_start_join  =>  '192.168.50.2',
      :pattern  =>  'spec/consul_spec.rb,spec/consul_daemon_cluster_spec.rb'
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
      ENV['CONSUL_BIND_ADDR'] = host[:consul_bind_addr]
      ENV['CONSUL_CLIENT_ADDR'] = host[:consul_client_addr]
      if host[:consul_bind_interface] then

        # Traivs specified.
        # IPAddress on Ruby: http://qiita.com/suu_g/items/a03af621f5d6985879e0
        require 'socket'
        private_ip = Socket.getifaddrs.select {|a|
          a.name == host[:consul_bind_interface] && a.addr.ipv4?
        }.first.addr.ip_address
        ENV['CONSUL_BIND_ADDR'] = private_ip
        ENV['CONSUL_CLIENT_ADDR'] = private_ip
      end
      ENV['CONSUL_DNS_PORT'] = host[:consul_dns_port]
      ENV['CONSUL_BOOTSTRAP_EXPECT'] = host[:consul_bootstrap_expect]
      ENV['CONSUL_START_JOIN'] = host[:consul_start_join]
      ENV['CONSUL_SERVER'] = host[:consul_server]
      t.pattern = host[:pattern]
    end
  end
end
