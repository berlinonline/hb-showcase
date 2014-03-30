<?php

$default_context = 'web';
$environment_modifier = '';

$base_directory = dirname(__DIR__);
require $base_directory . DIRECTORY_SEPARATOR . 'app' . DIRECTORY_SEPARATOR . 'bootstrap.php';

if (false !== strpos(\Honeybee\Core\Environment::getEnvironment(), 'development')) {
    PhpDebugToolbar::start(
        array(
            'js_location' => 'static/modules/Core/PhpDebugToolbar/PhpDebugToolbar.js',
            'css_location' => 'static/modules/Core/PhpDebugToolbar/PhpDebugToolbar.css'
        )
    );
}

AgaviContext::getInstance()->getController()->dispatch();
