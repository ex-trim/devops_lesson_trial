FROM nginx:1.23-alpine

ENV MUSL_LOCALE_DEPS cmake make musl-dev gcc gettext-dev libintl
ENV MUSL_LOCPATH /usr/share/i18n/locales/musl

RUN apk add --no-cache \
	$MUSL_LOCALE_DEPS \
	&& wget https://gitlab.com/rilian-la-te/musl-locales/-/archive/master/musl-locales-master.zip \
	&& unzip musl-locales-master.zip \
		&& cd musl-locales-master \
		&& cmake -DLOCALE_PROFILE=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install \
		&& cd .. && rm -r musl-locales-master && apk del $MUSL_LOCALE_DEPS

ENV LANG ru_RU.UTF-8
ENV LANGUAGE ru_RU.UTF-8
ENV LC_LANG ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8

RUN mkdir /var/www && rm -f /etc/nginx/conf.d/default.conf
COPY landing/. /var/www
COPY site.conf /etc/nginx/conf.d
RUN chown nginx:nginx -R /var/www
USER nginx