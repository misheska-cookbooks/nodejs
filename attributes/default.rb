default['nodejs']['install_dir'] = '/usr/local'
default['nodejs']['version'] = 'latest'
nodejs_version = node['nodejs']['version']
if nodejs_version.eql?('latest')
  default['nodejs']['binary_url'] = "http://nodejs.org/dist" \
    "/latest/node-v0.10.31-linux-x64.tar.gz"
  default['nodejs']['source_url'] = 'http://nodejs.org/dist/node-latest.tar.gz'
else
  default['nodejs']['binary_url'] = "http://nodejs.org/dist" \
    "/v#{nodejs_version}/node-v#{nodejs_version}-linux-x64.tar.gz"
  default['nodejs']['source_url'] = "http://nodejs.org/dist" \
    "/v#{nodejs_version}/node-v#{nodejs_version}.tar.gz"
end
