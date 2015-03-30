<?php

// get application directory
$application_dir = getenv('APPLICATION_DIR');
if ($application_dir === false) {
    throw new \Exception('APPLICATION_DIR not set. Application probably not set up correctly.');
}
$application_dir = realpath($application_dir);

AgaviConfig::set('core.testing_dir', realpath(__DIR__));
AgaviConfig::set('core.app_dir', $application_dir . DIRECTORY_SEPARATOR . 'app');
AgaviConfig::set('core.cache_dir', AgaviConfig::get('core.app_dir') . DIRECTORY_SEPARATOR . 'cache');
