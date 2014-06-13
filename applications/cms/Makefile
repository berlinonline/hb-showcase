# vim: ts=4:sw=4:noexpandtab!:

PROJECT_ROOT=`pwd`
BUILD_DIR=${PROJECT_ROOT}/etc/integration/build/
PHP_ERROR_LOG=`php -i | grep -P '^error_log' | cut -f '3' -d " "`
ENVIRONAUT_CACHE_LOCATION=${PROJECT_ROOT}/.environaut.cache
#GIT_FILE=`cat .git | sed -r 's/.+: (.+.git)(.*)/\1/'`
#LAST_FETCH_DATE=`git reflog show -n 1 --date=iso | cut -f '1-3' -d ':'`

help:

	@echo ""
	@echo "Honeybee makefile"
	@echo ""
	@echo "Current working directory : ${PROJECT_ROOT}"
	@echo "Environaut cache location : ${ENVIRONAUT_CACHE_LOCATION}"
	@echo "Local env config location : ${PROJECT_ROOT}/etc/local/"
	@echo "PHP error log file path   : ${PHP_ERROR_LOG}"
#	@echo "Project git-file location : ${PROJECT_ROOT}/${GIT_FILE}"
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
	@echo "  link-project              - Symlinks the project code into the honeybee submodule."
	@echo "  reconfigure-environment   - Runs environaut and overrides any exisitng environment configs."
	@echo "  tail-logs                 - Starts to tail all application logs and the php error-log."
	@echo "  update                    - Updates all vendor libraries (dev+prod) and the composer.lock file."
	@echo "  update-composer-lockfile  - Updates the composer.lock file with latest vendor library versions."
	@echo ""
	@echo "-------------------"
	@echo "DEVELOPMENT TARGETS"
	@echo "-------------------"
	@echo ""
	@echo "Scaffolding:"
	@echo ""
	@echo "  action                    - Creates a new action within an existing module."
	@echo "  module                    - Creates and links a new honeybee-module."
	@echo "  module-code               - Generates code for an existing honeybee-module."
	@echo ""
	@echo "Integration and reporting:"
	@echo ""
	@echo "  php-code-sniffer          - Runs the php code-sniffer."
	@echo "  php-copy-paste-detection  - Runs the php copy&paste detector."
	@echo "  php-dependencies          - Detmermines class dependecies/relation-topologie."
	@echo "  php-docs                  - Generates the php api doc for the project."
	@echo "  php-mess-detection        - Runs the php mess detector."
	@echo "  php-metrics               - Determines some source code metrics."
	@echo "  php-tests                 - Runs php test suites."
	@echo ""
	@exit 0


##################
# COMMON TARGETS #
##################

autoloads:

	@php bin/composer.phar dump-autoload --optimize

	@echo ""
	@echo "-> regenerated and optimized autoload files"


build-resources:

	@bin/cli core.util.compile_scss
	@bin/cli core.util.compile_js

	@echo ""
	@echo "-> binary, css and javascript resource packages where successfully built"


cc:

	-@rm -rf app/cache/*

	@make autoloads

	@echo ""
	@echo "-> cleared caches"


config:

	-@rm app/config/includes/*

	@bin/cli core.util.build_config --recovery

	@echo "-> built and included configuration files"

	@make cc


environment:

	@if [ ! -d etc/local/ ]; then mkdir etc/local; fi

	@vendor/bin/environaut check

	@echo ""
	@echo "-> environaut was successfully executed"
	@echo ""


install:

	@if [ ! -d data/assets ]; then mkdir -p data/assets; fi

	@if [ ! -f bin/composer.phar ]; \
	then \
		curl -s http://getcomposer.org/installer | php -d allow_url_fopen=1 -d date.timezone="Europe/Berlin" -- --install-dir=./bin; \
	else \
		bin/composer.phar self-update; \
	fi

	-@bin/revert-patches

	@php -d allow_url_fopen=1 bin/composer.phar install --optimize-autoloader

	-@bin/apply-patches

	@mkdir -p ./vendor/node_modules
	@npm install --prefix ./vendor

	@cd vendor && node_modules/honeybee/node_modules/.bin/bower install

	@make environment

	@make link-project

	@make build-resources


install-production:

	@if [ ! -f bin/composer.phar ]; \
	then \
		curl -s http://getcomposer.org/installer | php -d allow_url_fopen=1 -d date.timezone="Europe/Berlin" -- --install-dir=./bin; \
	else \
		bin/composer.phar self-update; \
	fi

	-@bin/revert-patches

	@php -d allow_url_fopen=1 bin/composer.phar install --no-dev --optimize-autoloader

	-@bin/apply-patches

	@mkdir -p ./vendor/node_modules
	@npm install --prefix ./vendor

	@cd vendor && node_modules/honeybee/node_modules/.bin/bower install

	@make environment

	@make link-project

	@make build-resources


link-project:

	@bin/cli core.util.link_project --recovery

	@make config

	@echo ""
	@echo "-> successfully linked the project into honeybee."


reconfigure-environment:

	@echo "Environaut cache file: ${ENVIRONAUT_CACHE_LOCATION}"

	@if [ -f "${ENVIRONAUT_CACHE_LOCATION}" ]; then rm ${ENVIRONAUT_CACHE_LOCATION} && echo "Deleted environaut cache."; fi

	@echo ""
	@echo "-> removed environaut cache, starting reconfiguration"

	@make environment


tail-logs:

	@tail -f "${PHP_ERROR_LOG}" app/log/*.log


#######################
# DEVELOPMENT TARGETS #
#######################

update:

	@make update-composer-lock-file

	@mkdir -p ./vendor/node_modules
	@npm install --prefix ./vendor

	@cd vendor && node_modules/honeybee/node_modules/.bin/bower update

	@make environment

	@make build-resources

update-composer-lock-file:

	@if [ ! -f bin/composer.phar ]; then echo "Please run make install first and do not run make update on non-dev machines."; fi

	@bin/composer.phar self-update

	-@bin/revert-patches

	@php -d allow_url_fopen=1 bin/composer.phar update --optimize-autoloader

	-@bin/apply-patches

action:

	@bin/agavi honeybee-action-wizard


module:

	@bin/agavi honeybee-module-wizard

	@make config


module-code:

# this should be "bin/agavi list-modules" again in the future to only show dat0r modules
	@echo "Available modules:"
	@echo ""
	@ls -1 app/modules/ | grep -v Core
	@echo ""

	@read -p "Enter Module Name: " module; \
    	dator_dir=app/modules/$$module/config/dat0r; \
		vendor/bin/dat0r.console generate_code gen+dep -c $$dator_dir/codegen.ini -s $$dator_dir/module.xml

	@make config

	@echo "-> successfully generated module classes."


php-code-sniffer:

	@/bin/mkdir -p ${BUILD_DIR}/logs

	-@vendor/bin/phpcs --report=checkstyle --report-file=${BUILD_DIR}/logs/checkstyle.xml \
		--standard=${PROJECT_ROOT}/etc/coding-standards/BerlinOnline/ruleset.xml \
		--ignore='app/cache*,*Success.php,*Input.php,*Error.php,app/templates/*,*.css,*.js' \
		${PROJECT_ROOT}/app


php-copy-paste-detection:

	@/bin/mkdir -p ${BUILD_DIR}/logs

	-@vendor/bin/phpcpd --log-pmd ${BUILD_DIR}/logs/pmd-cpd.xml app/


php-dependencies:

	@/bin/mkdir -p ${BUILD_DIR}/logs

	-@vendor/bin/pdepend --jdepend-xml=${BUILD_DIR}/logs/jdepend.xml \
		--jdepend-chart=${BUILD_DIR}/pdepend/dependencies.svg \
		--overview-pyramid=${BUILD_DIR}/logs/overview-pyramid.svg app/


php-docs:

	@if [ -d ${BUILD_DIR}/docs/api/serverside/ ]; then rm -rf ${BUILD_DIR}/docs/api/serverside/; fi

	@php vendor/bin/sami.php update app/config/sami.php


php-mess-detection:

	@/bin/mkdir -p ${BUILD_DIR}/logs

	-@vendor/bin/phpmd app/ xml codesize,design,naming,unusedcode --reportfile ${BUILD_DIR}/logs/pmd.xml


php-metrics:

	@/bin/mkdir -p ${BUILD_DIR}/logs

	-@vendor/bin/phploc --log-csv ${BUILD_DIR}/logs/phploc.csv app/


php-tests:

	@nice bin/test --configuration testing/config/phpunit.xml


#
# PHONY targets @see http://www.linuxdevcenter.com/pub/a/linux/2002/01/31/make_intro.html?page=2
#
.PHONY: help build-resources link-project module-code module reconfigure cc config install update update-composer-lock-file install-production
