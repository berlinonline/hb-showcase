class php::ext-mysql {

  package { 'php5-mysql':
    ensure => installed,
    notify => Service['php5-fpm']
  }
}
