nodejs_url = node['nodejs']['binary_url']
nodejs_tar_gz = ::File.basename(nodejs_url)
nodejs_basename = ::File.basename(nodejs_url, '.tar.gz')
nodejs_tarball_path = "#{Chef::Config[:file_cache_path]}/#{nodejs_tar_gz}"
nodejs_extract_path = node['nodejs']['install_dir']

begin
  node_version = Mixlib::ShellOut.new("#{nodejs_extract_path}/bin/node --version")
  node_version.run_command
  install_needed = !File.exists?("#{node['nodejs']['dir']}/bin/node") || node_version.stdout.chomp != "v#{node['nodejs']['version']}"
rescue
  install_needed = !File.exists?("#{node['nodejs']['dir']}/bin/node")
end

Chef::Log.info("mischa: nodejs_url=#{nodejs_url}")
Chef::Log.info("mischa: nodejs_tar_gz=#{nodejs_tar_gz}")
Chef::Log.info("mischa: nodejs_basename=#{nodejs_basename}")
Chef::Log.info("mischa: nodejs_tarball_path=#{nodejs_tarball_path}")
Chef::Log.info("mischa: nodejs_extract_path=#{nodejs_extract_path}")

remote_file nodejs_tarball_path do
  source nodejs_url
  notifies :run, "execute[unpack #{nodejs_tarball_path}]", :immediately
end

execute "unpack #{nodejs_tarball_path}" do
  command "tar --strip-components=1 -xvf #{nodejs_tarball_path} -C #{nodejs_extract_path} #{nodejs_basename}/bin #{nodejs_basename}/lib #{nodejs_basename}/share"
  action :nothing
  only_if { install_needed }
end
