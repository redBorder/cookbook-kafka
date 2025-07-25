# Cookbook:: kafka
# Provider:: config

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
    is_proxy = node['redborder']['is_proxy']
    is_manager = node['redborder']['is_manager']
    # Calculate kafka_topics that need to be created
    kafka_topics = []
    if is_manager
      kafka_topics = %w(rb_event rb_event_post
                      rb_flow rb_flow_post rb_flow_post_discard
                      rb_monitor rb_monitor_post
                      rb_loc rb_locne rb_loc_post rb_loc_post_discard rb_location
                      rb_trap
                      rb_mobile
                      rb_radius
                      rb_nmsp
                      rb_malware
                      rb_mail
                      rb_metrics
                      rb_state rb_state_post
                      rb_meraki
                      rb_vault rb_vault_post
                      rb_bi rb_bi_post
                      rb_scanner rb_scanner_post
                      rb_http2k_sync
                      rb_limits
                      rb_counters
                      sflow
                      rb_wireless)
      namespaces = []
      Chef::Role.list.each_key do |rol|
        ro = Chef::Role.load rol
        if ro && ro.override_attributes['redborder'] && ro.override_attributes['redborder']['namespace'] && ro.override_attributes['redborder']['namespace_uuid'] && !ro.override_attributes['redborder']['namespace_uuid'].empty?
          namespaces.push(ro.override_attributes['redborder']['namespace_uuid'])
        end
      end
      namespaces.uniq!
      topics_with_namespaces = %w(rb_flow_post rb_vault_post rb_loc_post rb_event_post rb_monitor_post rb_state_post rb_bi_post rb_scanner_post rb_wireless)
      namespaces.each do |ns|
        topics_with_namespaces.each do |topic|
          kafka_topics.push("#{topic}_#{ns}")
        end
      end
    end

    if is_proxy
      kafka_topics = %w(rb_event
                      rb_flow
                      rb_monitor
                      rb_loc
                      rb_nmsp
                      rb_social
                      rb_state
                      rb_radius
                      rb_vault
                      rb_hashtag
                      sflow
                      rb_scanner
                      rb_host_discovery
                      rb_wireless)
    end

    dnf_package 'redborder-kafka' do
      action :upgrade
    end

    execute 'create_user' do
      command "/usr/sbin/useradd #{user} -s /sbin/nologin"
      ignore_failure true
      not_if "getent passwd #{user}"
    end

    directory logdir do
      owner user
      group group
      mode '0770'
      action :create
    end

    directory '/tmp/kafka' do
      owner user
      group group
      mode '0755'
      action :create
    end

    directory '/etc/kafka' do
      owner user
      group group
      mode '0755'
    end

    template '/etc/kafka/consumer.properties' do
      source 'kafka_consumer.properties.erb'
      owner user
      group group
      cookbook 'kafka'
      mode '0644'
      retries 2
      variables(zk_hosts: zk_hosts)
    end

    template '/etc/kafka/log4j.properties' do
      source 'kafka_log4j.properties.erb'
      owner user
      group group
      mode '0644'
      cookbook 'kafka'
      retries 2
      notifies :restart, 'service[kafka]', :delayed
    end

    template '/etc/kafka/producer.properties' do
      source 'kafka_producer.properties.erb'
      owner user
      group group
      cookbook 'kafka'
      mode '0644'
      retries 2
      variables(managers_list: managers_list, port: port)
    end

    template '/etc/sysconfig/kafka' do
      source 'kafka_sysconfig.erb'
      owner user
      group group
      cookbook 'kafka'
      mode '0644'
      retries 2
      variables(memory: memory)
      notifies :restart, 'service[kafka]', :delayed
    end

    template '/etc/kafka/tools-log4j.properties' do
      source 'kafka_tools-log4j.properties.erb'
      owner user
      group group
      cookbook 'kafka'
      mode '0644'
      retries 2
    end

    template '/etc/kafka/server.properties' do
      source 'kafka_server.properties.erb'
      owner  user
      group group
      cookbook 'kafka'
      mode '0644'
      retries 2
      notifies :restart, 'service[kafka]', :delayed
      variables(is_proxy: is_proxy, managers_list: managers_list, host_index: host_index, zk_hosts: zk_hosts, maxsize: maxsize)
    end

    template '/etc/kafka/brokers.list' do
      source 'kafka_brokers.list.erb'
      owner user
      group group
      cookbook 'kafka'
      mode '0644'
      retries 2
      variables(managers_list: managers_list, port: port)
      notifies :restart, 'service[kafka]', :delayed if host_index >= 0
    end

    bootstrap_server = is_manager ? "#{node['name']}.node" : 'kafka.service'

    template '/etc/kafka/topics_definitions.yml' do
      source 'topics_definitions.yml.erb'
      owner user
      group group
      cookbook 'kafka'
      mode '0644'
      retries 2
      variables(kafka_topics: kafka_topics, managers_list: managers_list)
      notifies :run, 'bash[create_topics]', :delayed
      only_if "nc -zv #{bootstrap_server} 9092"
    end

    service 'kafka' do
      service_name 'kafka'
      supports status: true, reload: true, restart: true, start: true, enable: true
      action [:enable, :start]
    end

    #################################
    # BASH SCRIPTS
    #################################
    bash 'create_topics' do
      ignore_failure true
      code <<-EOH
          rvm ruby-2.7.5@global do /usr/lib/redborder/bin/rb_create_topics
        EOH
      user user
      group group
      action :nothing
    end

    Chef::Log.info('Kafka cookbook has been processed')
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin
    logdir = new_resource.logdir

    service 'kafka' do
      supports stop: true
      action :stop
    end

    template_list = %w(/etc/kafka/brokers.list
                       /etc/kafka/server.properties
                       /etc/kafka/tools-log4j.properties
                       /etc/sysconfig/kafka
                       /etc/kafka/producer.properties
                       /etc/kafka/log4j.properties
                       /etc/kafka/consumer.properties)

    dir_list = ['/etc/kafka', '/tmp/kafka', logdir]

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

    dnf_package 'redborder-kafka' do
      action :remove
    end

    Chef::Log.info('Kafka cookbook has been processed')
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :register do
  begin
    ipaddress = new_resource.ipaddress
    unless node['kafka']['registered']
      query = {}
      query['ID'] = "kafka-#{node['hostname']}"
      query['Name'] = 'kafka'
      query['Address'] = ipaddress
      query['Port'] = 9092
      json_query = Chef::JSONCompat.to_json(query)

      execute 'Register service in consul' do
        command "curl -X PUT http://localhost:8500/v1/agent/service/register -d '#{json_query}' &>/dev/null"
        action :nothing
      end.run_action(:run)

      node.normal['kafka']['registered'] = true
    end

    Chef::Log.info('Kafka services has been registered to consul')
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :deregister do
  begin
    if node['kafka']['registered']
      execute 'Deregister service in consul' do
        command "curl -X PUT http://localhost:8500/v1/agent/service/deregister/kafka-#{node['hostname']} &>/dev/null"
        action :nothing
      end.run_action(:run)

      node.normal['kafka']['registered'] = false
    end

    Chef::Log.info('Kafka services has been deregistered to consul')
  rescue => e
    Chef::Log.error(e.message)
  end
end
