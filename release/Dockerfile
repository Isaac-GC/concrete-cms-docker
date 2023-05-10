FROM ghcr.io/isaac-gc/concrete-cms-docker:base

ARG CCM_PHP_VERSION=8.2
# ARG CCM_COMPOSER_VERSION=2
ARG CCM_C5_ARCHIVE=https://github.com/concretecms/concretecms/archive/develop.tar.gz
# ARG CCM_STARTING_POINT=atomik_full

COPY build.sh /

RUN /build.sh && rm /build.sh