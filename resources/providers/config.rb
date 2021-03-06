# Cookbook Name:: kafka
#
# Provider:: config
#

action :add do
  begin
    memory = new_resource.memory
    logdir = new_resource.logdir
    user = new_resource.user
    group = new_resource.group
    zk_hosts = new_resource.zk_hosts
    host_index = new_resource.host_index
    port = new_resource.port
    managers_list = new_resource.managers_list
    maxsize = new_resource.maxsize

    yum_package "redborder-kafka" do
      action :upgrade
      flush_cache [ :before ]
    end

    user user do
      action :create
    end

    directory logdir do
      owner user
      group group
      mode 0770
      action :create
    end

    directory "/tmp/kafka" do
      owner user
      group group
      mode 0755
      action :create
    end

    directory "/etc/kafka" do
      owner user
      group group
      mode 0755
    end

    template "/etc/kafka/consumer.properties" do
      source "kafka_consumer.properties.erb"
      owner user
      group group
      cookbook "kafka"
      mode 0644
      retries 2
      variables(:zk_hosts => zk_hosts)
    end

    template "/etc/kafka/log4j.properties" do
      source "kafka_log4j.properties.erb"
      owner user
      group group
      mode 0644
      cookbook "kafka"
      retries 2
      notifies :restart, "service[kafka]", :delayed
    end

    template "/etc/kafka/producer.properties" do
      source "kafka_producer.properties.erb"
      owner user
      group group
      cookbook "kafka"
      mode 0644
      retries 2
      variables(:managers_list => managers_list, :port => port)
    end

     template "/etc/sysconfig/kafka" do
        source "kafka_sysconfig.erb"
        owner user
        group group
        cookbook "kafka"
        mode 0644
        retries 2
        variables(:memory => memory)
        notifies :restart, "service[kafka]", :delayed
    end

    template "/etc/kafka/tools-log4j.properties" do
      source "kafka_tools-log4j.properties.erb"
      owner user
      group group
      cookbook "kafka"
      mode 0644
      retries 2
    end

    template "/etc/kafka/server.properties" do
      source "kafka_server.properties.erb"
      owner  user
      group group
      cookbook "kafka"
      mode 0644
      retries 2
      notifies :restart, "service[kafka]", :delayed
     variables(:managers_list => managers_list, :host_index => host_index, :zk_hosts => zk_hosts, :maxsize => maxsize )
    end

    template "/etc/kafka/brokers.list" do
      source "kafka_brokers.list.erb"
      owner user
      group group
      cookbook "kafka"
      mode 0644
      retries 2
      variables(:managers_list => managers_list, :port => port)
      notifies :restart, "service[kafka]", :delayed if host_index>=0
    end

    service "kafka" do
      service_name "kafka"
      supports :status => true, :reload => true, :restart => true, :start => true, :enable => true
      action [:enable,:start]
    end

    Chef::Log.info("Kafka cookbook has been processed")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin

    logdir = new_resource.logdir
    host_index = new_resource.host_index

    service "kafka" do
      supports :stop => true
      action :stop
    end

    template_list = [
                     "/etc/kafka/brokers.list",
                     "/etc/kafka/server.properties",
                     "/etc/kafka/tools-log4j.properties",
                     "/etc/sysconfig/kafka",
                     "/etc/kafka/producer.properties",
                     "/etc/kafka/log4j.properties",
                     "/etc/kafka/consumer.properties"
                    ]

    dir_list = [
                 "/etc/kafka",
                 "/tmp/kafka",
                 logdir
               ]

    # removing templates
    template_list.each do |temp|
      file temp do
        action :delete
      end
    end

    # removing directories
    dir_list.each do |dirs|
      directory dirs do
        action :delete
        recursive true
      end
    end

    yum_package 'redborder-kafka' do
      action :remove
    end

    Chef::Log.info("Kafka cookbook has been processed")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :register do
  begin
    if !node["kafka"]["registered"]
      query = {}
      query["ID"] = "kafka-#{node["hostname"]}"
      query["Name"] = "kafka"
      query["Address"] = "#{node["ipaddress"]}"
      query["Port"] = 9092
      json_query = Chef::JSONCompat.to_json(query)

      execute 'Register service in consul' do
         command "curl http://localhost:8500/v1/agent/service/register -d '#{json_query}' &>/dev/null"
         action :nothing
      end.run_action(:run)

      node.set["kafka"]["registered"] = true
    end

    Chef::Log.info("Kafka services has been registered to consul")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :deregister do
  begin
    if node["kafka"]["registered"]
      execute 'Deregister service in consul' do
        command "curl http://localhost:8500/v1/agent/service/deregister/kafka-#{node["hostname"]} &>/dev/null"
        action :nothing
      end.run_action(:run)

      node.set["kafka"]["registered"] = false
    end

    Chef::Log.info("Kafka services has been deregistered to consul")
  rescue => e
    Chef::Log.error(e.message)
  end
end
