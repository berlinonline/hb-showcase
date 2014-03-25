# puppet manifests for a dev-box with nginx, php5-fpm and mysql

class boxes::devbox-php-mysql {
  include boxes::devbox

  # setup software for running php/mysql applications
  include subversion::client
  include git::client
  include php::fpm
  include php::ext-mailparse
  include mysql::server
  include php::ext-mysql
  include nginx::server

  package { 'rlwrap':
    ensure => installed
  }

}
