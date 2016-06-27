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
    managers_list = new_resource.managers_list
    maxsize = new_resource.maxsize

#    service "kafka" do
#        service_name "kafka"
#        supports :status => true, :reload => true, :restart => true, :start => true, :enable => true
#    end

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
      mode 0700
      action :create
    end

    directory "/etc/kafka" do
      owner owner
      group group 
      mode 0700
    end

    template "/etc/kafka/consumer.properties" do
      source "kafka_consumer.properties.erb"
      owner "root"
      group "root"
      cookbook "kafka"
      mode 0644
      retries 2
      variables(:zk_hosts => zk_hosts)
    end

    template "/etc/kafka/log4j.properties" do
      source "kafka_log4j.properties.erb"
      owner "root"
      group "root"
      mode 0644
      cookbook "kafka"
      retries 2
#      notifies :restart, "service[kafka]", :delayed 
    end

    template "/etc/kafka/producer.properties" do
      source "kafka_producer.properties.erb"
      owner "root"
      group "root"
      cookbook "kafka"
      mode 0644
      retries 2
      variables(:managers_list => managers_list)
    end  

     template "/etc/sysconfig/kafka" do
        source "kafka_sysconfig.erb"
        owner "root"
        group "root"
        cookbook "kafka"
        mode 0644
        retries 2
        variables(:memory => memory)
#        notifies :restart, "service[kafka]", :delayed 
    end

    template "/etc/kafka/tools-log4j.properties" do
      source "kafka_tools-log4j.properties.erb"
      owner "root"
      group "root"
      cookbook "kafka"
      mode 0644
      retries 2
    end 

    template "/etc/kafka/server.properties" do
      source "kafka_server.properties.erb"
      owner "root"
      group "root"
      cookbook "kafka"
      mode 0644
      retries 2
#      notifies :restart, "service[kafka]", :delayed
#     variables(:managers_list => managers_list, :manager_index => manager_index, :zk_hosts => zk_hosts, :maxsize => hd_services["kafka"] )
    end

    template "/opt/rb/etc/kafka/brokers.list" do
      source "kafka_brokers.list.erb"
      owner "root"
      group "root"
      cookbook "kafka"
      mode 0644
      retries 2
    #  variables(:managers => managers_per_service["kafka"])
    #  notifies :restart, "service[kafka]", :delayed if manager_services["kafka"] and manager_index>=0
    end
    
    Chef::Log.info("Kafka has been configurated correctly.")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin
    template_list = [
                     "/opt/rb/etc/kafka/brokers.list",
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
      file "/opt/rb/etc/kafka/brokers.list" do
        action :delete
      end
    end
  
    # removing directories
    dir_list.each do |dirs|
      directory dirs do
        action :delete
      end
    end
     Chef::Log.info("Kafka has been deleted correctly.")
  rescue => e
    Chef::Log.error(e.message)
  end
end

