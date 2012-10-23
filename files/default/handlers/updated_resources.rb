#
# Copyright:: 2011, Joshua Timberman <chefcode@housepub.org>
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

# Slightly modified by Kameron Kenny

require 'chef/handler'
require 'chef/log'

module SimpleReport
  class UpdatedResources < Chef::Handler
    def initialize(options={})
      @max_log_entries = (options[:max_log_entries] || 3).to_i
    end

    def report
      Chef::Log.info "Resources updated this run:"
      run_status.updated_resources.each do |resource|
	m = "recipe[#{resource.cookbook_name}::#{resource.recipe_name}] ran '#{resource.action}' on #{resource.resource_name} '#{resource.name}'"
        Chef::Log.info(m)

       # Save entries to node
	node[:log] ||= []
	node[:log].insert(0, {
	  :time => Time.now,
	  :cookbook_name => resource.cookbook_name,
	  :recipe_name => resource.recipe_name,
	  :action => resource.action,
	  :resource => resource.name,
	  :resource_type => resource.resource_name
	})
	# Rotate the old stuff out so we don't cloud the attributes.
	node[:log] = node[:log].first(@max_log_entries) if node[:log].length > @max_log_entries
      end
      #Do statistics
      stat = run_status.success? ? "Successful" : "Failed"
      node[:status] ||= []
      node[:status].insert(0, {
	:time => Time.now,
	:start_time => run_status.start_time,
	:end_time => run_status.end_time,
	:run_time => run_status.elapsed_time,
	:status => stat
      })
      node[:status] = node[:status].first(@max_log_entries) if node[:status].length > @max_log_entries
      node.save
    end
  end
end

