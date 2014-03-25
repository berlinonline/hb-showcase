# puppet manifests for a nfs server installation
class nfs {
  
  # writes a new /etc/exports file
  # takes an object like: {
  # '/path/exported/directory' => 'export_to_and_nfs_export_options',
  # '/home/jon' => '0.0.0.0/0.0.0.0(rw,insecure,sync)'
  # }
  define export( $exports ) {
    file { "/etc/exports":
      content => template("nfs/server/exports.erb"),
      ensure => present,
      owner => 'root',
      group => 'root',
      mode => '644',
      notify => Service['nfs-kernel-server']
    }
  }

  class server ($exports = '') {

    if '' != $exports {
      nfs::export {"/etc/exports":
        exports => $exports
      }
    }

    # opensuse nfs handling
    package {"nfs-kernel-server":
      ensure => installed,
    }
    -> service {"nfs-kernel-server":
      ensure => running,
      enable => true,
      require => Package["nfs-kernel-server"],
    }
  }
}
