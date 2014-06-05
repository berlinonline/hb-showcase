<?php

/*
 * you may register special autoloaders here
 */

// get application directory
$application_dir = getenv('APPLICATION_DIR');
if ($application_dir === false) {
    throw new \Exception('APPLICATION_DIR not set. Bootstrap aborted.');
}

die($application_dir . str_replace('/', DIRECTORY_SEPARATOR, '/vendor/berlinonline/honeybee/app/bootstrap'));

// bootstrap honeybee
require($application_dir . str_replace('/', DIRECTORY_SEPARATOR, '/vendor/berlinonline/honeybee/app/bootstrap'));

/*
 * you may set additional settings here:
 * AgaviConfig::set('omg', 'yeah');
 */

// set your application's default timezone
date_default_timezone_set('Europe/Berlin');

