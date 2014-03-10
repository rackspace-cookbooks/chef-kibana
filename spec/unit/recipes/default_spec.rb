#
# Cookbook Name:: kibana3
#
# Copyright 2014, Rackspace, UK, Ltd.
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

require 'spec_helper'

describe 'kibana' do
  kibana3_test_platforms.each do |platform, versions|
    describe "on #{platform}" do
      versions.each do |version|
        describe version do
          before :each do
            stub_command('chown -Rf kibana kibana /opt/kibana').and_return(true)
          end
          let(:chef_run) do
            runner = ChefSpec::Runner.new(platform: platform.to_s, version: version.to_s)
            runner.converge('kibana')
          end
          it 'include the git recipe' do
            expect(chef_run).to include_recipe 'git'
          end
          it 'populate the /opt/kibana directory' do
            expect(chef_run).to create_directory('/opt/kibana')
          end
          it 'populate the /etc/nginx directory' do
            expect(chef_run).to create_directory('/etc/nginx')
          end
          it 'populate the /var/log/nginx directory' do
            expect(chef_run).to create_directory('/var/log/nginx')
          end
          it 'populate the /var/run directory' do
            expect(chef_run).to create_directory('/var/run')
          end
          it 'populate the /etc/nginx/sites-available directory' do
            expect(chef_run).to create_directory('/etc/nginx/sites-available')
          end
          it 'populate the /etc/nginx/conf.d directory' do
            expect(chef_run).to create_directory('/etc/nginx/conf.d')
          end
          it 'populate the /etc/nginx/sites-enabled directory' do
            expect(chef_run).to create_directory('/etc/nginx/sites-enabled')
          end
          it 'populate the /etc/chef/ohai_plugins directory' do
            expect(chef_run).to create_remote_directory('/etc/chef/ohai_plugins')
          end
          it 'validates link current is there' do
            expect(chef_run).to create_link('/opt/kibana/current').with(to: '/opt/kibana/master')
          end
          it 'creates the template' do
            expect(chef_run).to create_template('/etc/chef/ohai_plugins/nginx.rb')
          end
          it 'creates the template' do
            expect(chef_run).to create_template('nginx.conf')
          end
          it 'creates the template' do
            expect(chef_run).to create_template('/etc/nginx/sites-available/default')
          end
          it 'creates the template' do
            expect(chef_run).to create_template('/usr/sbin/nxensite')
          end                    
          it 'creates the template' do
            expect(chef_run).to create_template('/usr/sbin/nxdissite')
          end
          it 'creates the template' do
            expect(chef_run).to create_template('/etc/nginx/sites-available/kibana')
          end
          it 'creates the template' do
            expect(chef_run).to create_template('/opt/kibana/current/config.js')
          end
          it 'installs git package' do
            expect(chef_run).to install_package('git')
          end
          it 'installs nginx package' do
            expect(chef_run).to install_package('nginx')
          end
          it 'changes installdir owner' do
            expect(chef_run).to run_execute('change installdir owner')
          end
          it 'execute nxensite kibana' do
            expect(chef_run).to run_execute('nxensite kibana')
          end
          it 'git /opt/kibana/master' do
            expect(chef_run).to sync_git('/opt/kibana/master')
          end
        end
      end
    end
  end
end
