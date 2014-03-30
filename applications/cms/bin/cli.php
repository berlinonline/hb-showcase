<?php

error_reporting(E_ALL | E_STRICT);
ini_set('display_startup_errors', 'On');

$default_context = 'console';
$environment_modifier = '';

if (in_array('--recovery', $argv)) {
    putenv('AGAVI_ENVIRONMENT=recovery');
}

$base_directory = dirname(dirname(__FILE__));
require  $base_directory . DIRECTORY_SEPARATOR . 'app' . DIRECTORY_SEPARATOR . 'bootstrap.php';

$response = AgaviContext::getInstance()->getController()->dispatch();
exit($response->getExitCode());
