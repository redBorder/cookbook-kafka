# Cookbook:: kafka
# Resource:: config

actions :add, :remove, :register, :deregister
default_action :add

attribute :memory, kind_of: Integer, default: 524288
attribute :logdir, kind_of: String, default: '/var/log/kafka'
attribute :user, kind_of: String, default: 'kafka'
attribute :group, kind_of: String, default: 'kafka'
attribute :host_index, kind_of: Integer, default: 0
attribute :zk_hosts, kind_of: String, default: 'localhost:2181'
attribute :managers_list, kind_of: Array, default: ['localhost']
attribute :port, kind_of: Integer, default: 9092
attribute :maxsize, kind_of: Integer, default: 1024
attribute :ipaddress, kind_of: String, default: '127.0.0.1'
