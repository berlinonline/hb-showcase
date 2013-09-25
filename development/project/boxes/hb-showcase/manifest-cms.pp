Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

# set our default package provider
Package { provider => 'apt' }

# set projects base directory, which is also exported to nfs.
$hosting_root = "/home/vagrant/projects"
$project_basedir = "${hosting_root}/hb-showcase-cms"

# define our concrete box configuration
class { 'boxes::devbox-php-couchdb': }
-> hb-showcase::application { 'hb-showcase-cms.local':
    app_docroot => "${project_basedir}/applications/cms/honeybee/pub"
}
