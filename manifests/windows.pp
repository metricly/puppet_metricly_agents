class puppet_metricly_agents::windows {
  $net_api_key_win = $puppet_metricly_agents::net_api_key_win
    file { 'C:/Temp':
      ensure => 'directory',
      owner  => 'Administrator',
      group => 'Administrators',
    }
    file { 'C:/Temp/CollectdWin-x64.msi':
      ensure => 'file',
      owner  => 'Administrator',
      group  => 'Administrators',
      source => "puppet:///modules/puppet_metricly_agents/CollectdWin-x64.msi",
      before => Package['CollectdWinService (64 bit)'],
    }
    package { 'CollectdWinService (64 bit)':
      ensure          => '{agentversion}', #replace {agentversion} with an agent version e.g 0.10.6.75
      source          => 'C:/Temp/CollectdWin-x64.msi',
      install_options => ['/quiet', "NETUITIVE_API_KEY=${net_api_key_win}",],
    }
    file { 'C:\Program Files\CollectdWin\config\WriteNetuitive.config':
      ensure  => present,
      content => template('puppet_metricly_agents/WriteNetuitive.config.erb'),
      require => Package['CollectdWinService (64 bit)'],
      before  => Service['CollectdWinService (64 bit)'],
    }
    file { 'C:\Program Files\CollectdWin\config\CollectdWin.config':
      ensure  => present,
      source  => 'puppet:///modules/puppet_metricly_agents/CollectdWin.config',
      require => Package['CollectdWinService (64 bit)'],
      before  => Service['CollectdWinService (64 bit)'],
    }

    service {'CollectdWinService (64 bit)':
      ensure    => 'running',
      require   => Package['CollectdWinService (64 bit)'],
      subscribe => [File['C:\Program Files\CollectdWin\config\WriteNetuitive.config'],
                    File['C:\Program Files\CollectdWin\config\CollectdWin.config']],
  }
}

