#
# Author:: Kameron Kenny <kkenny379@gmail.com>
# Cookbook Name:: chef_handler
# Recipe:: updated_resources
#
# Copyright 2012, Kameron Kenny
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# The ruby-shadow gem is required for this recipe to run.  Install it beforehand.

include_recipe "chef_handler::default"


#chef_handler "UpdatedResources" do
#  source "/var/chef/handlers/updated_resources"
#  action :nothing
#end.run_action(:enable)

require "#{node['chef_handler']['handler_path']}/updated_resources.rb"

Chef::Config.report_handlers << SimpleReport::UpdatedResources.new
Chef::Config.exception_handlers << SimpleReport::UpdatedResources.new

#Chef::Log.info "Resources updated this run:"
#      run_status.updated_resources.each {|r| Chef::Log.info "  #{r.to_s}"}
