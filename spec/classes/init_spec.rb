require 'spec_helper'

describe 'clickhouse' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      context 'with defaults' do
        it { is_expected.to contain_class('clickhouse::repo') }
      end

      context 'with manage_repo set to false' do
        let(:params) { { manage_repo: false } }

        it { is_expected.not_to contain_class('clickhouse::repo') }
      end

      context 'with apt_pin' do
        let(:facts) { os_facts }
        let(:params) { { apt_pin: '25.8.11.66' } }

        case os_facts[:os]['family']
        when 'Debian'
          it { is_expected.to contain_apt__pin('clickhouse').with(ensure: 'present') }
        end
      end
    end
  end
end
