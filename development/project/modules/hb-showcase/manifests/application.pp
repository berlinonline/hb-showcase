define hb-showcase::application (
  $app_name = $title,
  $app_docroot = '/home/vagrant/projects/hb-showcase/applications/cms/honeybee/pub'
) {

  require zeromq
  require kestrel

  nginx::site { "${app_name}":
    name => $app_name,
    docroot => "${app_docroot}"
  }

  file { '/etc/apache_tika':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '0644'
  }
  -> exec { 'wget http://www.apache.org/dyn/closer.cgi/tika/tika-app-1.5.jar':
    cwd => '/etc/apache_tika',
    timeout => -1,
    unless => 'ls /etc/apache_tika/tika-app-1.5.jar'
  }

  file {
    "/home/vagrant/init_fe.sh":
      ensure  => present,
      mode    => '0744',
      owner   => 'vagrant',
      group   => 'vagrant',
      content => template('hb-showcase/init_fe.sh.erb');
    "/home/vagrant/init_cms.sh":
      ensure  => present,
      mode    => '0744',
      owner   => 'vagrant',
      group   => 'vagrant',
      content => template('hb-showcase/init_cms.sh.erb');
    "/home/vagrant/cms_project_environaut.xml":
      ensure  => present,
      replace => false,
      mode    => '0744',
      owner   => 'vagrant',
      group   => 'vagrant',
      content => template('hb-showcase/project_environaut.xml.erb');
  }
}
