#!/bin/sh

# if container has been recreated
if [ ! -f /opt/drupal/recreated ]; then
    # set time
    apk add tzdata && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime && echo "Europe/Paris" > /etc/timezone && apk add tzdata
    # set composer plugins config 
    composer config --no-interaction --no-plugins allow-plugins.composer/installers true
    composer config --no-interaction --no-plugins allow-plugins.drupal/core-composer-scaffold true
    composer config --no-interaction --no-plugins allow-plugins.drupal/core-project-message true

    touch /opt/drupal/recreated
fi

# if core is not present, install drupal and drush
if [ ! -d /opt/drupal/web/core ]; then
    # install with optimizations
    composer install --no-interaction -o
    # setup needed for next installation steps
    chown www-data: /opt/drupal/web -R
    mkdir -p /opt/drupal/web/sites/default/files/translations
    cp -p /opt/drupal/web/sites/default/default.settings.php /opt/drupal/web/sites/default/settings.php
    # install modules
    drush pmu search -y
    mkdir -p /opt/drupal/web/libraries/jquery-ui-touch-punch
    wget https://raw.githubusercontent.com/furf/jquery-ui-touch-punch/master/jquery.ui.touch-punch.min.js -O /opt/drupal/web/libraries/contrib/jquery-ui-touch-punch/jquery.ui.touch-punch.min.js
    drush en search_api_solr backup_migrate tamper feeds feeds_ex feeds_tamper better_exposed_filters views_infinite_scroll -y
fi
