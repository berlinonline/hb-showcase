class zeromq {

  $libzmq = [
    'libzmq3-dev',
    'libzmq3-dbg',
    'libzmq3',
  ]

  package { $libzmq:
    ensure => installed
  }

  package { 'pkg-config':
    ensure => installed
  }
  -> exec { 'printf "\n" | sudo pecl install zmq-beta':
    require => [
      Package['libzmq3']
    ],
    unless => 'php -i | grep zmq'
  }
  -> file { 'cli-zmq.ini':
    path    => "/etc/php5/cli/conf.d/zmq.ini",
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("zeromq/zmq.ini.erb"),
  }
  -> file { 'fpm-zmq.ini':
    path    => "/etc/php5/fpm/conf.d/zmq.ini",
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("zeromq/zmq.ini.erb"),
    notify  => Service['php5-fpm']
  }
}
