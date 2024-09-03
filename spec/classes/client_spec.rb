require 'spec_helper'

describe 'clickhouse::client' do
  _, os_facts = on_supported_os.first
  let(:facts) { os_facts }

  it { is_expected.to compile }

  context 'with defaults' do
    it { is_expected.to contain_package('clickhouse-client') }
    it { is_expected.to contain_class('clickhouse::repo') }
  end

  context 'with manage_package set to true' do
    let(:params) { { manage_package: true } }

    it { is_expected.to contain_package('clickhouse-client') }
  end

  context 'with manage_package set to false' do
    let(:params) { { manage_package: false } }

    it { is_expected.not_to contain_package('clickhouse-client') }
  end

  context 'with specific version' do
    let(:params) do
      {
        manage_package: true,
        package_ensure: '24.8.2.3'
      }
    end

    it { is_expected.to contain_package('clickhouse-client').with(ensure: '24.8.2.3') }
    it { is_expected.to contain_package('clickhouse-common-static').with(ensure: '24.8.2.3') }
  end

  context 'with manage_repo set to false' do
    let(:pre_condition) { 'class { "clickhouse": manage_repo => false }' }

    it { is_expected.not_to contain_class('clickhouse::repo') }
    it { is_expected.to contain_package('clickhouse-client') }
  end
end
