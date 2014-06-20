# vim: ts=4:sw=4:noexpandtab!:

PROJECT_DIR=`pwd`
LOCAL_CONFIG_SH = $(wildcard etc/local/config.sh)

ifneq "${LOCAL_CONFIG_SH}" ""
	include ${LOCAL_CONFIG_SH}
endif

ifeq "${PHP_COMMAND}" ""
	PHP_COMMAND=php
endif

PHP_ERROR_LOG=`${PHP_COMMAND} -i | grep -P '^error_log' | cut -f '3' -d " "`
ENVIRONAUT_CACHE_LOCATION=${PROJECT_DIR}/.environaut.cache

#GIT_FILE=`cat .git | sed -r 's/.+: (.+.git)(.*)/\1/'`
#LAST_FETCH_DATE=`git reflog show -n 1 --date=iso | cut -f '1-3' -d ':'`

help:

	@echo ""
	@echo "Honeybee makefile"
	@echo ""
	@echo "Current working directory : ${PROJECT_DIR}"
	@echo "Environaut cache location : ${ENVIRONAUT_CACHE_LOCATION}"
	@echo "Local env config location : ${PROJECT_DIR}/etc/local/"
	@echo "PHP executable            : ${PHP_COMMAND}"
	@echo "PHP error log file path   : ${PHP_ERROR_LOG}"
#	@echo "Project git-file location : ${PROJECT_DIR}/${GIT_FILE}"
#	@echo ""
#	@echo "Last working copy update  : ${LAST_FETCH_DATE}"
	@echo ""
	@echo "--------------"
	@echo "COMMON TARGETS"
	@echo "--------------"
	@echo ""
	@echo "  autoloads                 - Generate and optimize autoloads."
	@echo "  build-resources           - Builds css and javascript production packages for the project."
	@echo "  cc                        - Purges/clears the application caches."
	@echo "  config                    - Generates the configuration includes for all (agavi) modules."
	@echo "  environment               - Run environaut and configure environment."
	@echo "  install                   - Installs vendor (development) libraries and runs environaut."
	@echo "  install-production        - Installs vendor (production) libraries and runs environaut."
	@echo "  link-project              - Creates module symlinks and copies core honeybee modules into this app."
	@echo "  reconfigure-environment   - Runs environaut and overrides any exisitng environment configs."
	@echo "  tail-logs                 - Starts to tail all application logs and the php error-log."
	@echo ""
	@echo "-------------------"
	@echo "DEVELOPMENT TARGETS"
	@echo "-------------------"
	@echo ""
	@echo "  update                    - Updates all vendor libraries (dev+prod) and the composer.lock file."
	@echo "  update-composer-lockfile  - Updates the composer.lock file with latest vendor library versions."
	@echo ""
#	@echo "Scaffolding:"
#	@echo ""
#	@echo "  action                    - Creates a new action within an existing module."
#	@echo "  module                    - Creates and links a new honeybee-module."
#	@echo "  module-code               - Generates code for an existing honeybee-module."
	@echo ""
	@echo "Integration and reporting:"
	@echo ""
	@echo "  php-code-sniffer          - Runs the php code-sniffer."
	@echo "  php-api-docs              - Generates the php api doc for the project."
	@echo "  php-mess-detection        - Runs the php mess detector."
	@echo "  php-metrics               - Determines some source code metrics."
	@echo "  php-tests                 - Runs php test suites."
	@echo ""
	@exit 0


##################
# COMMON TARGETS #
##################

autoloads:

	@echo "[INFO] Regenerating (optimized) autoload files:"
	@${PHP_COMMAND} bin/composer.phar dump-autoload --optimize
	@echo "[INFO] Regenerated and optimized autoload files."


build-resources:

	@make link-project

	@echo "[INFO] Trying to compile SCSS files from all themes and modules:"
	@bin/cli core.util.compile_scss

	@echo "[INFO] Trying to compile JS files from all modules:"
	@bin/cli core.util.compile_js

	@echo "[INFO] Built CSS/JS from all themes and modules."


cc:

	@echo "[INFO] Clearing cache directories."
	-@rm -rf app/cache/*

	@make autoloads

	@echo "[INFO] Cleared caches."


config:

	@echo "[INFO] Creating (proxy) config files in app/config/includes folder."
	-@rm app/config/includes/*

	@bin/cli core.util.build_config --recovery

	@echo "[INFO] Built and included configuration files for all modules."

	@make cc


environment:

	@echo "[INFO] Configuring environment of this application."
	@if [ ! -d etc/local/ ]; then mkdir -p etc/local; fi

	@vendor/bin/environaut check

	@echo "[INFO] Environaut was successfully executed."


install:

	@make folders

	@echo "[INFO] Installing or updating composer locally."
	@if [ ! -f bin/composer.phar ]; \
	then \
		curl -s http://getcomposer.org/installer | ${PHP_COMMAND} -d allow_url_fopen=1 -d date.timezone="Europe/Berlin" -- --install-dir=./bin; \
	else \
		bin/composer.phar self-update; \
	fi

	@echo "[INFO] Reverting known local patches to vendor libraries."
	-@bin/revert-patches

	@echo "[INFO] Installing vendor libraries with optimized autoloader via composer."
	@${PHP_COMMAND} -d allow_url_fopen=1 bin/composer.phar install --optimize-autoloader

	@echo "[INFO] Applying known local patches to vendor libraries."
	-@bin/apply-patches

	@echo "[INFO] Installing npm (node modules) into vendor/node_modules."
	@mkdir -p ./vendor/node_modules
	@npm install --prefix ./vendor

	@echo "[INFO] Installing (updating) bower (clientside libraries) into vendor/bower_components."
	@cd vendor && node_modules/honeybee/node_modules/.bin/bower update

	@echo "[INFO] Downloading additional dependencies from package.txt files."
	@bin/wget_packages

	@make environment

	@make build-resources


install-production:

	@make folders

	@echo "[INFO] Installing or updating composer locally."
	@if [ ! -f bin/composer.phar ]; \
	then \
		curl -s http://getcomposer.org/installer | ${PHP_COMMAND} -d allow_url_fopen=1 -d date.timezone="Europe/Berlin" -- --install-dir=./bin; \
	else \
		bin/composer.phar self-update; \
	fi

	@echo "[INFO] Reverting known local patches to vendor libraries."
	-@bin/revert-patches

	@echo "[INFO] Installing vendor libraries with optimized autoloader via composer."
	@${PHP_COMMAND} -d allow_url_fopen=1 bin/composer.phar install --no-dev --optimize-autoloader

	@echo "[INFO] Applying known local patches to vendor libraries."
	-@bin/apply-patches

	@echo "[INFO] Installing npm (node modules) into vendor/node_modules."
	@mkdir -p ./vendor/node_modules
	@npm install --prefix ./vendor

	@echo "[INFO] Installing bower (clientside libraries) into vendor/bower_components."
	@cd vendor && node_modules/honeybee/node_modules/.bin/bower install

	@echo "[INFO] Downloading additional dependencies from package.txt files."
	@bin/wget_packages

	@make environment

	@make build-resources


link-project:

	@make copy-honeybee-core-modules
	@make copy-honeybee-core-themes
	@make copy-honeybee-core-schemas

	@make config

	@echo "[INFO] Successfully copied/linked honeybee files into the project."


reconfigure-environment:

	@echo "[INFO] Environaut cache file: ${ENVIRONAUT_CACHE_LOCATION}"

	@if [ -f "${ENVIRONAUT_CACHE_LOCATION}" ]; then rm ${ENVIRONAUT_CACHE_LOCATION} && echo "[INFO] Deleted environaut cache."; fi

	@echo "[INFO] Removed environaut cache, starting reconfiguration."

	@make environment


tail-logs:

	@tail -f "${PHP_ERROR_LOG}" app/log/*.log


copy-honeybee-core-modules:

	@echo "[INFO] Copying honeybee default modules into this application."
	@cp -R ./vendor/berlinonline/honeybee/app/modules/Core app/modules/
	@cp -R ./vendor/berlinonline/honeybee/app/modules/User app/modules/


copy-honeybee-core-themes:

	@echo "[INFO] Copying honeybee default themes into this application."
	@cp -R ./vendor/berlinonline/honeybee/pub/static/themes/* pub/static/themes/


copy-honeybee-core-schemas:

	@echo "[INFO] Copying honeybee config schema files (XSDs) into this application."
	@cp -R ./vendor/berlinonline/honeybee/app/config/xsd/* app/config/xsd/


folders:

	@echo "[INFO] Creating cache, log and asset folders (if missing)."
	@if [ ! -d app/cache ]; then mkdir -p app/cache; fi
	@if [ ! -d app/log ]; then mkdir -p app/log; fi
	@if [ ! -d data/assets ]; then mkdir -p data/assets; fi
	@chmod 755 app/cache
	@chmod 755 app/log
	@chmod 755 data/assets

	@if [ ! -d build/codebrowser ]; then mkdir -p build/codebrowser; fi
	@if [ ! -d build/logs ]; then mkdir -p build/logs; fi
	@if [ ! -d build/docs ]; then mkdir -p build/docs; fi
	@chmod 755 build/codebrowser
	@chmod 755 build/docs
	@chmod 755 build/logs


#
#
# DEVELOPMENT TARGETS
#
#

update:

	@echo "[INFO] TRYING TO UPDATE ALL VENDOR DEPENDENCIES TO LATEST VERSIONS."

	@make folders

	@echo "[INFO] Updating composer.lock file with latest versions."
	@make update-composer-lock-file

	@echo "[INFO] Updating npm (node modules) with latest versions."
	@mkdir -p ./vendor/node_modules
	@npm update --prefix ./vendor

	@echo "[INFO] Updating bower (clientside libraries) with latest versions."
	@cd vendor && node_modules/honeybee/node_modules/.bin/bower update

	@echo "[INFO] Downloading additional dependencies from package.txt files."
	@bin/wget_packages

	@make environment

	@make build-resources


update-composer-lock-file:

	@if [ ! -f bin/composer.phar ]; then echo "Please run MAKE INSTALL first and do not run make update on non-dev machines."; fi

	@bin/composer.phar self-update

	@echo "[INFO] Reverting known local patches to vendor libraries."
	-@bin/revert-patches

	@echo "[INFO] Updating vendor library versions in composer.lock and generating optimized autoloads."
	@${PHP_COMMAND} -d allow_url_fopen=1 bin/composer.phar update --optimize-autoloader

	@echo "[INFO] Applying known local patches to vendor libraries."
	-@bin/apply-patches


#action:
#
#	@bin/agavi honeybee-action-wizard
#
#
#module:
#
#	@bin/agavi honeybee-module-wizard
#
#	@make config
#
#
#module-code:
#
## this should be "bin/agavi list-modules" again in the future to only show dat0r modules
#	@echo "Available modules:"
#	@echo ""
#	@ls -1 app/modules/ | grep -v Core
#	@echo ""
#
#	@read -p "Enter Module Name: " module; \
#    	dator_dir=app/modules/$$module/config/dat0r; \
#		vendor/bin/dat0r.console generate_code gen+dep -c $$dator_dir/codegen.ini -s $$dator_dir/module.xml
#
#	@make config
#
#	@echo "-> successfully generated module classes."


#
#
# TESTING AND CODE QUALITY METRICS
#
#

php-metrics: folders

	@if [ -d build/codebrowser ]; then rm -rf build/codebrowser; fi

	@nice bin/test
	@vendor/bin/phpcs --extensions=php --report=checkstyle --report-file=build/logs/checkstyle.xml --standard=psr2 \
		--ignore='app/cache*,*Success.php,*Input.php,*Error.php,app/templates/*,resources/*,*.scss,*.css,*.js' \
		app tests
	-@vendor/bin/phpcpd --log-pmd ./build/logs/pmd-cpd.xml app/
	-@vendor/bin/phpmd app/ xml codesize,design,naming,unusedcode --reportfile build/logs/pmd.xml
	-@vendor/bin/phpcb --log build/logs/ --source app/ --output build/codebrowser/
	-@vendor/bin/phploc --log-csv build/logs/phploc.csv app/


php-api-docs: folders

	@if [ -d build/docs ]; then rm -rf build/docs; fi

	@${PHP_COMMAND} vendor/bin/sami.php update app/config/sami.php


php-code-sniffer:

	-@vendor/bin/phpcs --extensions=php --standard=psr2 \
		--ignore='app/cache*,*Success.php,*Input.php,*Error.php,app/templates/*,resources/*,*.scss,*.css,*.js' \
		app tests


php-tests:

	@bin/test --no-configuration tests/


php-mess-detection: folders

	-@vendor/bin/phpmd app/ xml codesize,design,naming,unusedcode


php-loc: folders

	-@vendor/bin/phploc app/


#
# PHONY targets @see http://www.linuxdevcenter.com/pub/a/linux/2002/01/31/make_intro.html?page=2
# vim: ts=4:sw=4:noexpandtab!:
#
.PHONY: help build-resources link-project module-code module reconfigure cc config install update update-composer-lock-file install-production copy-honeybee-core-modules copy-honeybee-core-themes copy-honeybee-core-schemas folders php-tests php-api-docs php-code-sniffer php-mess-detection php-loc
