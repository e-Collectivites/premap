#!/bin/sh

# if translations is not present, install drupal and drush
if [ ! -d /opt/drupal/web/sites/default/files/translations ]; then
    # install with optimizations
    composer install --no-interaction -o
    # setup needed for next installation steps
    chown www-data: /opt/drupal/web -R
    mkdir -p /opt/drupal/web/sites/default/files/translations
    cp -p /opt/drupal/web/sites/default/default.settings.php /opt/drupal/web/sites/default/settings.php
    # install modules
    cd /opt/drupal/web
    drush pmu search -y
    mkdir -p /opt/drupal/web/libraries/jquery-ui-touch-punch /opt/drupal/web/libraries/jq-multiselect
    wget https://raw.githubusercontent.com/furf/jquery-ui-touch-punch/master/jquery.ui.touch-punch.min.js -O /opt/drupal/web/libraries/jquery-ui-touch-punch/jquery.ui.touch-punch.min.js
    wget https://raw.githubusercontent.com/nobleclem/jQuery-MultiSelect/master/jquery.multiselect.js -O /opt/drupal/web/libraries/jq-multiselect/jquery.multiselect.js
    wget https://raw.githubusercontent.com/nobleclem/jQuery-MultiSelect/master/jquery.multiselect.css -O /opt/drupal/web/libraries/jq-multiselect/jquery.multiselect.css
    drush en search_api_solr backup_migrate tamper feeds feeds_ex feeds_tamper better_exposed_filters views_infinite_scroll -y
fi

# if container has been recreated
if [ ! -f /opt/drupal/recreated ]; then
    # set time
    apk add tzdata
    cp /usr/share/zoneinfo/Europe/Paris /etc/localtime && echo "Europe/Paris" > /etc/timezone
    apk add tzdata
    # if recreated, some files miss and updating fixes it
    cd /opt/drupal
    composer update search_api_solr
    docker-php-ext-install mysqli && docker-php-ext-enable mysqli

    touch /opt/drupal/recreated
fi