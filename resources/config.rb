# Cookbook Name:: kafka
#
# Resource:: config
#

actions :add, :remove
default_action :add

attribute :memory, :kind_of => String, :default => "512m"
attribute :logdir, :kind_of => String, :default => "/var/log/kafka"
attribute :user, :kind_of => String, :default => "kafka"
attribute :group, :kind_of => String, :default => "kafka"
attribute :zk_hosts, :kind_of => Array, :default => ["localhost"]
attribute :managers_list, :kind_of => Array, :default => ["localhost"]
attribute :port, :kind_of => Fixnum, :default => 9092
attribute :maxsize, :kind_of => Fixnum, :default => 1024


