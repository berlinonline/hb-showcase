<?php

error_reporting(E_ALL | E_STRICT);
ini_set('display_startup_errors', 'On');

$base_directory = dirname(dirname(__FILE__));
$default_context = 'console';
$environment_modifier = '';

if (in_array('--recovery', $argv)) {
    putenv('AGAVI_ENVIRONMENT=recovery');
}

require($base_directory . DIRECTORY_SEPARATOR . 'app' . DIRECTORY_SEPARATOR . 'bootstrap.php');

unset($base_directory, $default_context, $environment_modifier);

$response = AgaviContext::getInstance()->getController()->dispatch();
exit($response->getExitCode());
