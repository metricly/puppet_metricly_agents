class puppet_metricly_agents::linux {
  $net_api_key_linux = $puppet_metricly_agents::net_api_key_linux
  if $::osfamily == 'redhat' {
    exec { 'install netuitive-agent repo yum':

  creates => '/etc/yum.repos.d/netuitive.repo',
  command => 'rpm --import https://repos.app.netuitive.com/RPM-GPG-KEY-netuitive && rpm -ivh https://repos.app.netuitive.com/rpm/noarch/netuitive-repo-1-0.2.noarch.rpm',
  path    => '/usr/bin',
    }
    package { 'netuitive-agent':
      ensure => '{agentversion}', #replace {agentversion} with an agent version e.g. 0.7.6-188.el6
      before => Service['netuitive-agent'],
    }
}
  if $::osfamily == 'debian' {
    exec { 'install netuitive-agent repo apt':

  creates => '/etc/apt/sources.list.d/netuitive.list',
  command => 'curl -s https://repos.app.netuitive.com/netuitive.gpg | apt-key add && echo "deb https://repos.app.netuitive.com/deb/ stable main" > /etc/apt/sources.list.d/netuitive.list',
  path    => ['/usr/bin', '/bin'],
    }
    package { 'netuitive-agent':
      ensure => '{agentversion}', #replace {agentversion} with an agent version e.g. 0.7.6-188.el6
      before => Service['netuitive-agent'],
    }
}
    file { '/opt/netuitive-agent/conf/netuitive-agent.conf':
      ensure  => present,
      content => template('puppet_metricly_agents/netuitive-agent.conf.erb'),
      require => Package['netuitive-agent'],
      notify  => Service['netuitive-agent'],
    }
    service { 'netuitive-agent':
      ensure  => 'running',
      require => File['/opt/netuitive-agent/conf/netuitive-agent.conf'],
    }
}