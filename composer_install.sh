#!/bin/sh

# if core is present, the install is already performed
if [ ! -d /opt/drupal/web/core ]; then
    # set time
    cp /usr/share/zoneinfo/Europe/Paris /etc/localtime
    # set composer plugins config 
    composer config --no-interaction --no-plugins allow-plugins.composer/installers true
    composer config --no-interaction --no-plugins allow-plugins.drupal/core-composer-scaffold true
    composer config --no-interaction --no-plugins allow-plugins.drupal/core-project-message true
    # install with optimizations
    composer install --no-interaction -o
    # setup needed for next installation steps
    chown www-data: /opt/drupal/web -R
    mkdir -p /opt/drupal/web/sites/default/files/translations
    cp -p /opt/drupal/web/sites/default/default.settings.php /opt/drupal/web/sites/default/settings.php
    # install drush
    composer require drush/drush
fi
