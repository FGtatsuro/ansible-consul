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
      :consul_group  =>  'staff'
    },
    {
      :name     =>  'container',
      :backend  =>  'docker',
      :consul_config_remote_dir =>  '/etc/consul.d',
      :consul_owner  =>  'root',
      :consul_group  =>  'root'
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
      t.pattern = "spec/consul_spec.rb"
    end
  end
end
