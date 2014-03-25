class zeromq {

  $libpgm = [
    'libpgm-dev',
    'libpgm-dbg',
    'libpgm-5.1-0',
  ]

  $libzmq = [
    'libzmq3-dev',
    'libzmq3-dbg',
    'libzmq3',
  ]

  apt::ppa { 'ppa:chris-lea/libpgm':
  }
  -> package { $libpgm:
    ensure => installed
  }

  apt::ppa { 'ppa:chris-lea/zeromq':
  }
  -> package { $libzmq:
    ensure => installed
  }

  package { 'pkg-config':
    ensure => installed
  }
  -> exec { 'printf "\n" | pecl install zmq-beta':
    require => [
      Apt::Ppa['ppa:chris-lea/zeromq'],
      Apt::Ppa['ppa:chris-lea/libpgm']
    ],
    unless => 'php -i | grep zmq'
  }

  file { 'cli-zmq.ini':
    path    => "/etc/php5/cli/conf.d/zmq.ini",
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("zeromq/zmq.ini.erb")
  }

  file { 'fpm-zmq.ini':
    path    => "/etc/php5/fpm/conf.d/zmq.ini",
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("zeromq/zmq.ini.erb"),
    notify  => Service['php5-fpm']
  }
}
