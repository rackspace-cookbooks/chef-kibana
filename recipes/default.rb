#
# Cookbook Name:: kibana
# Recipe:: default
#
# Copyright 2013, John E. Vincent
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

include_recipe 'git'

if node['rackspace_kibana']['user'].empty?
  rackspace_kibana_user = node['nginx']['user']
else
  rackspace_kibana_user = node['rackspace_kibana']['user']
end

directory node['rackspace_kibana']['installdir'] do
  owner rackspace_kibana_user
  mode '0755'
end

git "#{node['rackspace_kibana']['installdir']}/#{node['rackspace_kibana']['branch']}" do
  repository node['rackspace_kibana']['repo']
  reference node['rackspace_kibana']['branch']
  action :sync
end

link "#{node['rackspace_kibana']['installdir']}/current" do
  to "#{node['rackspace_kibana']['installdir']}/#{node['rackspace_kibana']['branch']}"
end

template "#{node['rackspace_kibana']['installdir']}/current/config.js" do
  source node['rackspace_kibana']['config_template']
  cookbook node['rackspace_kibana']['config_cookbook']
  mode '0750'
end

include_recipe "rackspace_kibana::#{node['rackspace_kibana']['webserver']}"

execute 'change installdir owner' do
  command "chown -Rf #{rackspace_kibana_user}.#{rackspace_kibana_user} #{node['rackspace_kibana']['installdir']}"
  only_if { Etc.getpwuid(File.stat(node['rackspace_kibana']['installdir']).uid).name != rackspace_kibana_user }
  action :run
end
