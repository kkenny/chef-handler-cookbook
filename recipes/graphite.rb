include_recipe "chef_handler::default"

if node[:chef_client][:graphite][:write_metrics] == "1"

  gem_package "chef-handler-graphite" do
    action :install
  end

  argument_array = [
    :metric_key => "chef-client.#{node['hostname']}",
    :graphite_host => node[:graphite][:vip],
    :graphite_port => 2013
  ]

  Chef::Log.info "Will write chef-client metrics to #{node[:graphite][:vip]} with chef-client.#{node['hostname']} as the metric key"

  chef_handler "GraphiteReporting" do
    source "#{node['chef_handler']['handler_path']}/chef-handler-graphite.rb"
    arguments argument_array
    action :enable
  end
else
  Chef::Log.info "Not writing metrics for chef-client"
end
