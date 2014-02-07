define hb-showcase::application (
  $app_name = $title,
  $app_docroot = '/home/vagrant/projects/hb-showcase/applications/cms/honeybee/pub'
) {

  require kestrel

  nginx::site { "${app_name}":
    name => $app_name,
    docroot => "${app_docroot}"
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
