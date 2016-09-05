FROM dockenizer/alpine
MAINTAINER Jacques Moati <jacques@moati.net>

RUN apk --update add mysql && \
    rm -rf /var/cache/apk/*

