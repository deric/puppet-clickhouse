require 'spec_helper'

describe 'clickhouse::repo' do
  context 'on Debian' do
    let(:facts) do
      {
        os: {
          family: 'Debian',
          name: 'Debian',
          release: {
            major: '12',
          },
        },
        osfamily: 'Debian',
      }
    end

    it {
      is_expected.to contain_apt__source('clickhouse').with(
        name: 'clickhouse',
        location: 'https://packages.clickhouse.com/deb',
        release: 'stable main',
        repos: '',
      )
    }
  end

  context 'on RedHat' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'CentOS',
          release: {
            major: '7',
          },
        },
        osfamily: 'RedHat',
      }
    end

    it {
      is_expected.to contain_yumrepo('clickhouse-stable').with(
        name: 'clickhouse-stable',
        baseurl: 'https://packages.clickhouse.com/rpm/stable/',
        enabled: 1,
        gpgcheck: 0,
        gpgkey: 'https://packages.clickhouse.com/rpm/stable/repodata/repomd.xml.key',
      )
    }
  end
end
