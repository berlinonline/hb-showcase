# puppet manifest for an Ubuntu box to host CKAN
# this manifest only install the required packages -
# the actual CKAN installation takes place in a recipe in 'projects'
# (e.g., projects::ckan18)

class boxes::ckan {

	# system configuration
	# require sysconfig::users
	# require sysconfig::repositories
	require sysconfig::misc
	
	require python::dev
	require python::venv

	# ssh configuration for vagrant and root
    # include ssh::server
    # ssh::user { "vagrant": 
    #     home => "/home/vagrant"
    # }
    # ssh::user { "root":
    #     home => "/root"
    # }

# also here commented out, since I'm running puppet apply locally,
# and can assume that the apt repositories are already set and updated
# correctly
# in addition, there was a weird cycle (that I did not experience in the
# vagrant setup)
    # if $running_in_vagrant == 'true' {
    #     warning("running in vagrant, therefore setting apt source lists")
    #     class { 'sysconfig::repositories':
    #         version => $version
    #     }
    # }
    # else {
    #     warning("not running in vagrant, therefore not setting apt source lists")
    # }

	# setup nfs-exports so we can mount our project for development
	class { 'nfs::server':
		exports => {
			"$::home" => '0.0.0.0/0.0.0.0(anonuid=1000,anongid=100,no_subtree_check,rw,insecure,all_squash)'
		}
	}

	# I need the following packages:
	# sudo apt-get install python-dev postgresql libpq-dev python-pip python-virtualenv git-core solr-jetty openjdk-6-jdk

	# not using the java::sun module, because that installs openjdk-7-jre, but I need openjdk-6-jdk
	package { 'openjdk-6-jdk':
		ensure => installed
	}

	package { 'solr-jetty':
		ensure => installed
	}

	package { 'git-core':
		ensure => installed
	}

	package { 'python-pip':
		ensure => installed
	}

	package { 'libpq-dev':
		ensure => installed
	}
	
	package { 'apache2':
		ensure => installed
	}

	package { 'libapache2-mod-wsgi':
		ensure => installed
	}


}
