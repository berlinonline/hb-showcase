# puppet manifests for a dev-box with nginx, php5-fpm, elasticsearch

class boxes::devbox-php-elasticsearch {
  include boxes::devbox

  # setup software for running php/elasticsearch applications
  include php::fpm
  include php::ext-mailparse
  include nginx::server
  include nodejs
  include elasticsearch

  package { 'sass':
      ensure   => 'installed',
      provider => 'gem',
  }
}
