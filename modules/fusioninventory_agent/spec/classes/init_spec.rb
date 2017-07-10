require 'spec_helper'
describe 'fusioninventory_agent' do

  context 'with default values for all parameters' do
    it { should contain_class('fusioninventory_agent') }
  end
end
