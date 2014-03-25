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
    'php5-zmq',
  ]

  apt::ppa { 'ppa:chris-lea/libpgm':
  }
  -> apt::ppa { 'ppa:chris-lea/zeromq':
  }
  -> package { $libpgm:
    ensure => installed
  }
  -> package { $libzmq:
    ensure => installed
  }
}
