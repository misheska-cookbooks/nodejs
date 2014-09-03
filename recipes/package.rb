case node['platform_family']
when 'rhel'
  include_recipe 'yum-epel'
  pkgs = %w{ nodejs nodejs-devel npm }
when 'debian'
  include_recipe 'apt'
  pkgs = %w{ nodejs npm }
else
  pkgs = %w{ nodejs npm }
end

pkgs.each do |pkg|
  package pkg
end
