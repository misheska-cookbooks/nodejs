require 'spec_helper'

describe 'nodejs::package' do
  let (:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

#  it 'installs' do
#    expect(chef_run).to install_package('httpd')
#  end
end
