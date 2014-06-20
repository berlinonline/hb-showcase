<?php

// get application directory
$application_dir = getenv('APPLICATION_DIR');
if ($application_dir === false) {
    throw new \Exception('APPLICATION_DIR not set. Aborting.');
}

// autoload files, setup agavi etc.
require($application_dir . str_replace('/', DIRECTORY_SEPARATOR, '/vendor/autoload.php'));
require($application_dir . str_replace('/', DIRECTORY_SEPARATOR, '/vendor/berlinonline/honeybee/app/config.php'));
require($application_dir . str_replace('/', DIRECTORY_SEPARATOR, '/tests/config.php'));
require($application_dir . str_replace('/', DIRECTORY_SEPARATOR, '/vendor/agavi/agavi/src/testing/AgaviTesting.class.php'));

// make generated files group writeable for easy switch between web/console
umask(02);

// by default the environment name is not modified via a suffix
if (!isset($environment_modifier)) {
    $environment_modifier = '';
}

// load local config and make it accessible via a static class
Honeybee\Core\Environment::load($environment_modifier);
AgaviConfig::set('core.clean_environment', Honeybee\Core\Environment::getCleanEnvironment());

AgaviTesting::bootstrap(Honeybee\Core\Environment::toEnvString());

AgaviToolkit::clearCache();

// workaround to prevent session_start() warnings after previous output
session_start();

AgaviTesting::getCodeCoverageFilter()->addDirectoryToBlacklist(AgaviConfig::get('core.cache_dir'));
AgaviTesting::getCodeCoverageFilter()->addDirectoryToBlacklist(AgaviConfig::get('core.agavi_dir'));

AgaviTesting::dispatch(AgaviTesting::processCommandlineOptions());
