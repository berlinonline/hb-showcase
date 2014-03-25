# puppet manifests for a basic dev-box

class boxes::devbox {

  # system configuration
  require sysconfig::users
  #require sysconfig::repositories

  # ssh configuration for vagrant and root
  include ssh::server
  ssh::user { "vagrant": 
    home => "/home/vagrant"
  }
  ssh::user { "root":
    home => "/root"
  }

  # setup nfs-exports so we can mount our project for development
  class { 'nfs::server':
    exports => {
      "$::hosting_root" => '0.0.0.0/0.0.0.0(anonuid=1000,anongid=100,no_subtree_check,rw,insecure,all_squash)'
    }
  }

  # setup samba share to access projects from windows machines
  class { 'samba::server':
    shareName => 'Projects',
    sharePath => '/home/vagrant/projects'
  }

  # basic software our box should have
  include base_packages
  include locales
  include bash
  include cron
  include ntp
  include sysctl
  class { 'timezone':
    timezone => 'Europe/Berlin'
  }
  include vim
  include wget
  include subversion::client
  include git::client

  # make the box' host name resolvable via zeroconf
  include avahi::daemon
}

