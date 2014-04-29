name 'rackspace_kibana'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Installs and configures kibana'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'

%w(ubuntu debian redhat centos).each do |os|
  supports os
end

%w(git nginx apache2).each do |cb|
  depends cb
end
