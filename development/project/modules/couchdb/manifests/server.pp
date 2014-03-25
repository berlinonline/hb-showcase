
class couchdb::server {
  file { "/etc/couchdb":
    ensure => directory,
    owner => "root",
    group => "root"
  }
  -> file{"default.ini":
    path    => "/etc/couchdb/default.ini",
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("couchdb/default.ini.erb"),
    notify  => Service['couchdb'],
  }
  -> package { 'couchdb':
    ensure => installed
  }
  -> service { 'couchdb':
    ensure => running,
    enable => true
  }
}
