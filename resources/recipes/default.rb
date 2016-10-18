#
# Cookbook Name:: kafka
# Recipe:: default
#
# Copyright 2016, redborder
#
# All rights reserved - Do Not Redistribute
#
#

kafka_config "Kafka node configuration" do
  zk_hosts node["kafka"]["zk_hosts"]
  host_index node["kafka"]["host_index"]
  port node["kafka"]["port"]
  action :add
end

