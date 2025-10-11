FROM alpine:3.22.2

# Cache buster for occasionally resetting the cached images for the yum commands
ENV LAST_UPDATED 2024-12-01

ADD wait-for-it.sh /usr/bin/

# https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html
COPY apk-world /etc/apk/world

# install from apk-world
RUN apk add --no-cache

RUN cpanm Devel::CheckLib HTTP::Date LWP::Simple DBI CPAN && rm -fr ~/.cpanm

# latest versions don't support MySQL 5.7
RUN cpanm -n https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-4.051.tar.gz && rm -fr ~/.cpanm
RUN perl -MDBD::mysql -e ''

# tests fail on Alpine because some locale issue that doesn't matter for our use
RUN cpanm -n Number::Format && rm -fr ~/.cpanm

ADD perl-modules /tmp/.modules

# install all the cpan stuff we need
RUN cpanm < /tmp/.modules; rm -fr ~/.cpanm; rm -fr /usr/local/share/man;

# install csso-cli, uglify-js to minimize css and js; "hulk" to compile js templates
RUN npm install -g \
  hogan.js source-map-support \
  uglify-js \
  csso csso-cli \
  && chown -R root:root /usr/lib/node_modules && rm -fr ~/.npm

USER root
