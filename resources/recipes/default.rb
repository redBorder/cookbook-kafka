# Cookbook:: kafka
# Recipe:: default
# Copyright:: 2024, redborder
# License:: Affero General Public License, Version 3

kafka_config 'Kafka node configuration' do
  zk_hosts node['kafka']['zk_hosts']
  host_index node['kafka']['host_index']
  port node['kafka']['port']
  action :add
end
