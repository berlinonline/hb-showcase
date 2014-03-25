# puppet manifests for a dev-box with nginx, php5-fpm, elasticsearch

class boxes::devbox-jekyll-php {
  include boxes::devbox

  # setup basic software for running our web applications
  include php::fpm
  include php::ext-mailparse
  include nginx::server
  include jekyll
}
