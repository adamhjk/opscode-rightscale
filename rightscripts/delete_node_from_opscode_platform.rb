#!/usr/bin/ruby
#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2010 Opscode, Inc.
# License:: Apache License, Version 2.0
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

if File.exists?("/etc/chef/client.rb") && File.exists?("/usr/bin/chef-client")
  require 'rubygems'
  require 'chef'
  require 'chef/knife'
  require 'chef/knife/node_delete'
  require 'chef/knife/client_delete'

  Chef::Config.from_file("/etc/chef/client.rb")

  nd = Chef::Knife::NodeDelete.new
  nd.name_args = [ Chef::Config[:node_name] ]
  nd.config[:yes] = true
  nd.run

  cd = Chef::Knife::ClientDelete.new
  cd.name_args = [ Chef::Config[:node_name] ]
  cd.config[:yes] = true
  cd.run

  File.unlink("/etc/chef/client.pem")
else
  puts "This node is not connected to Opscode, no need to delete node."
end

exit 0

