# Class: puppet_metricly_agents
# ===========================
#
# Full description of class puppet_metricly_agents here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'puppet_metricly_agents':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2019 Your name here, unless otherwise noted.
#
#replace undef with your linux and windows api keys wrapped in single quotes
class puppet_metricly_agents(
  $net_api_key_linux = undef,
  $net_api_key_win   = undef,
  ) {

  if ($net_api_key_linux == undef or $net_api_key_win == undef) {
    warning('Please enter a Metricly API key')
    notify { 'Please enter a Metricly API key': }
  }
  if ($::osfamily == 'redhat' or $::osfamily == 'debian') {
    include puppet_metricly_agents::linux
  }
  if $::osfamily == 'windows' {
    include puppet_metricly_agents::windows
  }
}
