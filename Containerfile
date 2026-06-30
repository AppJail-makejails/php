ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/base:${FREEBSD_RELEASE}

ARG PHPVER

LABEL org.opencontainers.image.title="PHP" \
    org.opencontainers.image.description="While designed for web development, the PHP scripting language also provides general-purpose use" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/php" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/php" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN pkg update && \
    pkg install php${PHPVER} php${PHPVER}-readline && \
    pkg clean -a && \
    rm -rf /var/cache/pkg/* /var/db/pkg/repos/*

RUN set -eux; \
    \
    PREFIX=/usr/local; \
    ETCDIR=${PREFIX}/etc; \
	PHP_FPM_DIR=${ETCDIR}/php-fpm.d; \
    WWWDIR=${PREFIX}/www; \
	\
    cp -v ${ETCDIR}/php.ini-production ${ETCDIR}/php.ini; \
    \
	# comment out localhost-only listen address
	grep -Ee '^listen = 127.0.0.1:9000' ${PHP_FPM_DIR}/www.conf; \
	sed -i '' -Ee 's/^(listen = 127.0.0.1:9000)/;\1/' ${PHP_FPM_DIR}/www.conf; \
	grep -Ee '^;listen = 127.0.0.1:9000' ${PHP_FPM_DIR}/www.conf; \
	\
	{ \
		echo '[global]'; \
		echo 'error_log = /dev/stderr'; \
		echo; echo '; https://github.com/docker-library/php/pull/725#issuecomment-443540114'; echo 'log_limit = 8192'; \
		echo; \
		echo '[www]'; \
		echo '; php-fpm closes STDOUT on startup, so sending logs to /dev/stdout does not work.'; \
		echo '; https://bugs.php.net/bug.php?id=73886'; \
		echo 'access.log = /dev/stderr'; \
		echo; \
		echo 'clear_env = no'; \
		echo; \
		echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
		echo 'catch_workers_output = yes'; \
		echo 'decorate_workers_output = no'; \
		echo; \
		echo '; default listen address for easy override in later php-fpm.d/*.conf files'; \
		echo 'listen = 9000'; \
	} | tee ${PHP_FPM_DIR}/appjail.conf; \
	{ \
		echo '[global]'; \
		echo 'daemonize = no'; \
		echo; \
		echo '; the [www] ini section below is for backwards compatibility and will be removed in 8.6+'; \
		echo '[www]'; \
	} | tee ${PHP_FPM_DIR}/zz-appjail.conf; \
    \
    if [ "${WWWDIR}" ]; then \
        mkdir -p "${WWWDIR}"; \
        chown www:www "${WWWDIR}"; \
        chmod 1777 "${WWWDIR}"; \
    fi

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Override stop signal to stop process gracefully
# https://github.com/php/php-src/blob/17baa87faddc2550def3ae7314236826bc1b1398/sapi/fpm/php-fpm.8.in#L163
STOPSIGNAL SIGQUIT

EXPOSE 9000
WORKDIR /usr/local/www
ENTRYPOINT ["/entrypoint.sh"]
