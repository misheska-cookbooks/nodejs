require 'spec_helper'

describe 'nodejs' do
  it 'has node installed' do
    case RSpec.configuration.os
    when 'Debian'
      expect(command 'nodejs -v').to return_exit_status(0)
    else
      expect(command 'node -v').to return_exit_status(0)
    end
  end

  it 'has npm installed' do
    expect(command 'npm -v').to return_exit_status(0)
  end
end
