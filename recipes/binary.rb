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

remote_file nodejs_tarball_path do
  Chef::Log.info("Downloading #{nodejs_tarball_path} from #{nodejs_url}")
  source nodejs_url
  notifies :run, "execute[unpack #{nodejs_tarball_path}]", :immediately
end

execute "unpack #{nodejs_tarball_path}" do
  Chef::Log.info("Extracting #{nodejs_tarball_path} to #{nodejs_extract_path}")
  command "tar --strip-components=1 -xvf #{nodejs_tarball_path} -C #{nodejs_extract_path} #{nodejs_basename}/bin #{nodejs_basename}/lib #{nodejs_basename}/share"
  action :nothing
  only_if { install_needed }
end
