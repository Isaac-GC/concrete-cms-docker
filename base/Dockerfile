FROM ubuntu:20.04

ENV C5_SUDOAS=www-data

ARG DEBIAN_FRONTEND=noninteractive

ARG PHP_VERSIONS="8.2"
ARG PHP_EXTENSIONS_VSPECIFIC="bcmath bz2 curl exif ftp gd gmp imagick imap intl json ldap mbstring mysql opcache pdo soap ssh2 xml xsl zip"
ARG PHP_EXTENSIONS_COMMON="php-redis"

COPY assets/scripts/ccm-help /usr/local/bin/
COPY assets/scripts/ccm-service /usr/local/bin/
COPY assets/entrypoint.sh /
COPY assets/bashrc /root/.bashrc
COPY build /

ADD https://raw.githubusercontent.com/concrete5-community/cli/master/c5 /usr/local/bin/
ADD https://raw.githubusercontent.com/concrete5-community/cli/master/composerpkg /usr/local/bin/

EXPOSE 80 \
       3306 \
       9000

RUN /build.sh \
    && rm /build.sh

COPY assets/nginx.conf /etc/nginx/sites-available/default

WORKDIR /app

ENTRYPOINT [ "/entrypoint.sh" ]