FROM alpine:3.18.4

# Cache buster for occasionally resetting the cached images for the yum commands
ENV LAST_UPDATED 2023-02-12


# https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html
COPY apk-world /etc/apk/world

# install from apk-world
RUN apk add --no-cache

RUN curl -sfLo /usr/bin/confd \
  https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 && \
  chmod a+x /usr/bin/confd

RUN cpanm Devel::CheckLib HTTP::Date LWP::Simple DBI CPAN && rm -fr ~/.cpanm

RUN cpanm -n https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-4.051.tar.gz && rm -fr ~/.cpanm
RUN perl -MDBD::mysql -e ''

ADD perl-modules /tmp/.modules

# install all the cpan stuff we need
RUN cpanm < /tmp/.modules; rm -fr ~/.cpanm; rm -fr /usr/local/share/man;

# install csso-cli, uglify-js to minimize css and js; "hulk" to compile js templates
RUN npm install -g \
  hogan.js gulp-cli source-map-support \
  uglify-js \
  csso csso-cli \
  && chown -R root:root /usr/lib/node_modules && rm -fr ~/.npm

ADD wait-for-it.sh /usr/bin/

USER root
