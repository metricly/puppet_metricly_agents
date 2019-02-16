require 'spec_helper'
describe 'puppet_metricly_agents' do
  context 'with default values for all parameters' do
    it { should contain_class('puppet_metricly_agents') }
  end
end
