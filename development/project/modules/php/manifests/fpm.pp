# puppet manifests for a php5-fpm installation
class php::fpm {

  $fpm_service_name = 'php5-fpm'

  # main php package
  package { 'php5-fpm':
    ensure => installed,
  }

  # extensions for ubuntu|debian
  package {
    'php5-dev':
      ensure => installed;
    'php5-cli':
      ensure => installed;
  }

  package {
    'php5-xsl':
      ensure  => installed,
      require => Package['php5-fpm'];
    'php5-intl':
      ensure  => installed,
      require => Package['php5-fpm'];
    'php5-ldap':
      ensure  => installed,
      require => Package['php5-fpm'];
    'php5-gd':
      ensure  => installed,
      require => Package['php5-fpm'];
    'php5-curl':
      ensure  => installed,
      require => Package['php5-fpm'];
    'php-apc':
      ensure  => installed,
      require => Package['php5-fpm'];
    'php5-imagick':
      ensure  => installed,
      require => Package['php5-fpm'];
    'php5-memcache':
      ensure  => installed,
      require => Package['php5-fpm'];
  }

  file {
    '/etc/php5/fpm/php.ini':
      ensure  => present,
      content => template('php/php-fpm.ini.erb'),
      notify  => Service[$fpm_service_name],
      require => Package['php5-fpm'];
    '/etc/php5/fpm/php-fpm.conf':
      ensure  => file,
      content => template('php/fpm_pool.conf.erb'),
      notify  => Service[$fpm_service_name],
      require => Package['php5-fpm'];
    '/etc/php5/cli/php.ini':
      ensure  => present,
      content => template('php/php-cli.ini.erb'),
      require => Package['php5-cli'];
    '/var/log/php':
      ensure => 'directory',
      owner  => 'vagrant',
      group  => 'users',
      mode   => '0744';
  }

  service { $fpm_service_name:
    ensure  => running,
    require => [
      File['/var/log/php'],
      Package['php5-fpm']
    ]
  }

}
