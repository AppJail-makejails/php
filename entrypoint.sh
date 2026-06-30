#!/bin/sh

set -e

if [ -n "${PHP_USE_FPM}" ]; then
    PROCESS=php-fpm

    if [ $# -eq 0 ]; then
        set -- "${PROCESS}"
    fi
else
    PROCESS=php

    if [ $# -eq 0 ]; then
        set -- "${PROCESS}" "-a"
    fi
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- "${PROCESS}" "$@"
fi

exec "$@"
