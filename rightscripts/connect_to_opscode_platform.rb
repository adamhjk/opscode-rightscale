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

if !ENV['OPSCODE_ORGANIZATION'] || !ENV['OPSCODE_NODE_NAME'] || !ENV['OPSCODE_VALIDATION_KEY']
  puts "One of the required fields (OPSCODE_ORGANIZATION, OPSCODE_NODE_NAME, OPSCODE_VALIDATION_KEY) was missing, skipping connection to Opscode platform..."
  exit 0
end

system("gem install json")

require 'rubygems'
require 'json'

server_name     = ENV['RSSERVER_NAME']          || "n/a"
deployment      = ENV['RSDEPLOYMENT_NAME']      || "n/a"
server_template = ENV['RSSERVER_TEMPLATE_NAME'] || "n/a"

unless File.exists?("/usr/bin/chef-client")
  system("gem install chef ohai --no-rdoc --no-ri --verbose") unless File.exists?("/usr/bin/chef-client")
  system("mkdir -p /etc/chef && chmod -R 755 /etc/chef")
  File.open("/etc/chef/validation.pem", "w") do |f|
    f.print ENV["OPSCODE_VALIDATION_KEY"]
  end
  File.open("/etc/chef/client.rb", "w") do |f|
    f.print <<-EOH
log_level        :info
log_location     STDOUT
chef_server_url  "https://api.opscode.com/organizations/#{ENV['OPSCODE_ORGANIZATION']}" 
validation_client_name "#{ENV['OPSCODE_ORGANIZATION']}-validator"
node_name "#{ENV['OPSCODE_NODE_NAME']}"
    EOH
  end
  run_list = []
  run_list = ENV['OPSCODE_INITIAL_RUN_LIST'].split(' ') if ENV['OPSCODE_INITIAL_RUN_LIST']

  # Fetch the existing RightScale node attributes, in particular the monitoring server(s)
  attr_json = File.open('/etc/rightscale.d/chef.js','r').read
  attr_obj = JSON.parse(attr_json)
  rs_attrs = attr_obj['attributes']['rightscale']

  File.open("/etc/chef/first-boot.json", "w") do |f|
    f.print({ "run_list" => run_list, "rightscale" => rs_attrs.merge({ "server_name" => server_name, "deployment" => deployment, "server_template" => server_template }) }.to_json)
  end
end

