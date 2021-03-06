include_recipe 'apt' if platform_family?('debian')
include_recipe 'build-essential'

nodejs_source_url = node['nodejs']['source_url']
nodejs_tar_gz = ::File.basename(nodejs_source_url)
nodejs_basename = ::File.basename(nodejs_source_url, '.tar.gz')
nodejs_tarball_path = "#{Chef::Config[:file_cache_path]}/#{nodejs_tar_gz}"
nodejs_extract_path = "#{Chef::Config[:file_cache_path]}/#{nodejs_basename}"
nodejs_install_path = node['nodejs']['install_dir']

# node_version = Mixlib::ShellOut.new("#{nodejs_extract_path}/bin/node --version")
# node_version.run_command
# install_needed = !File.exists?("#{node['nodejs']['dir']}/bin/node") || \
#  node_version.stdout.chomp != "v#{node['nodejs']['version']}"
install_needed = !File.exists?("#{node['nodejs']['dir']}/bin/node")

num_cores = Mixlib::ShellOut.new('cat /proc/cpuinfo | grep processor | wc -l')
num_cores.run_command
num_build_threads = num_cores.stdout.to_i + 1

directory nodejs_extract_path

remote_file nodejs_tarball_path do
  Chef::Log::info("Downloading #{nodejs_tarball_path} from #{nodejs_source_url}")
  source nodejs_source_url
  notifies :run, "execute[unpack #{nodejs_tarball_path}]", :immediately
  notifies :run, "execute[build #{nodejs_tarball_path}]", :immediately
end

execute "unpack #{nodejs_tarball_path}" do
  Chef::Log::info("Extracting #{nodejs_tarball_path} to #{nodejs_extract_path}")
  command "tar --strip-components=1 -xvf #{nodejs_tarball_path} -C #{nodejs_extract_path}"
  action :nothing
  only_if { install_needed }
end

execute "build #{nodejs_tarball_path}" do
  command "./configure --prefix=#{nodejs_install_path} && make -j #{num_build_threads.to_s} && make install"
  cwd "#{nodejs_extract_path}"
  action :nothing
  only_if { install_needed }
end
