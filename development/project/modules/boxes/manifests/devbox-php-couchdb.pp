# puppet manifests for a dev-box with nginx, php5-fpm, couchdb and elasticsearch

class boxes::devbox-php-couchdb {
    include boxes::devbox-php-elasticsearch
    include couchdb::server

    package { 'python-pip':
        ensure => $ensure,
    }

    python::pip::install { 'httpie':
        venv => '/usr',
        require => Package['python-pip'],
    }
}
