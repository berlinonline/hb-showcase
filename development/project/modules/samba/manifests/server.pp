#puppet manifest for a samba file server
class samba {
  class server (
    $shareName = 'Vagrant',
    $sharePath = '/home/vagrant'
  ) {
    package {'patterns-openSUSE-minimal_base-conflicts':
      ensure => absent;
    }
    package {'samba':
      ensure => installed,
      require => $operatingsystem ? {
        'OpenSuSE' => Package['patterns-openSUSE-minimal_base-conflicts'], #needed to fix conflict with SuSE samba package
        default => []
      }
    }
    service {'smbd':
      name => $operatingsystem ? {
        'OpenSuSE' => "smb",
        default => "smbd"
      },
      ensure => running;
    }
    file {'smb.conf':
      path => '/etc/samba/smb.conf',
      ensure => present,
      owner => 'root',
      group => 'root',
      mode => '0644',
      content => template('samba/smb.conf.erb'),
      notify => Service['smbd'],
      require => Package['samba'];
    }
  }
}

