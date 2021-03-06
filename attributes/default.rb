default['nodejs']['install_dir'] = '/usr/local'
default['nodejs']['version'] = 'latest'
if node['nodejs']['version'].eql?('latest')
  default['nodejs']['binary_url'] = "http://nodejs.org/dist" \
    "/latest/node-v0.10.31-linux-x64.tar.gz"
  default['nodejs']['source_url'] = 'http://nodejs.org/dist/node-latest.tar.gz'
else
  default['nodejs']['binary_url'] = "http://nodejs.org/dist" \
    "/v#{node['nodejs']['version']}/node-v#{node['nodejs']['version']}-linux-x64.tar.gz"
  default['nodejs']['source_url'] = "http://nodejs.org/dist" \
    "/v#{node['nodejs']['version']}/node-v#{node['nodejs']['version']}.tar.gz"
end
