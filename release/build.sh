#!/bin/sh

set -o errexit
set -o nounset

printTitle() {
    printTitle_length=${#1}
    printf "\n##%${printTitle_length}s##\n" ' ' | tr ' ' '#'
    printf '# %s #\n' "$1"
    printf "##%${printTitle_length}s##\n" ' ' | tr ' ' '#'
}

printTitle 'Configuring environment'
cd /app
ccm-service start db

printTitle 'Downloading and extracting ConcreteCMS'
printf '(URL: %s)\n' "$CCM_C5_ARCHIVE"
if test "$CCM_C5_ARCHIVE" != "${CCM_C5_ARCHIVE#https://github.com/}" || test "$CCM_C5_ARCHIVE" != "${CCM_C5_ARCHIVE#https://codeload.github.com/}"; then
    curl -sSL "$CCM_C5_ARCHIVE" | sudo -u www-data -- tar xz --strip 1
else
    curl -sSL -o /tmp/c5.zip "$CCM_C5_ARCHIVE"
    sudo -u www-data -- mkdir /tmp/c5
    sudo -u www-data -- unzip -q /tmp/c5.zip -d /tmp/c5
    mv /tmp/c5/*/** /app
    rm -rf /tmp/c5.zip /tmp/c5
    chmod +x concrete/bin/concrete5
fi

if ! test -d concrete/vendor; then
    printTitle 'Installing composer dependencies'
    if test -f concrete/composer.json; then
        sed -i 's/"hautelook\/phpass"/"ozh\/phpass"/' concrete/composer.json
    fi
    if test -f composer.lock; then
        sed -i 's_\bhautelook/phpass\b_ozh/phpass_' composer.lock
    fi
    sudo -H -u www-data -- composer install --optimize-autoloader --no-cache
fi

printTitle 'Installing Concrete'
c5 c5:install \
    --db-server=localhost \
    --db-username=c5 \
    --db-password=12345 \
    --db-database=c5 \
    --site='ConcreteCMS website' \
    --starting-point="elemental_full" \
    --admin-email=admin@example.org \
    --admin-password=12345 \

c5 c5:config set -g concrete.seo.url_rewriting true

printTitle 'Final operations'
c5 c5:clear-cache
ccm-service stop db

printTitle 'Ready.'