FROM alpine:3.8

# Cache buster for occasionally resetting the cached images for the yum commands
ENV LAST_UPDATED 2018-12-03

RUN \
  echo @testing http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories; \
  apk --no-cache update; apk --no-cache upgrade; \
  apk --no-cache add gosu@testing; \
  apk --no-cache add curl git \
  perl-dev wget make bash build-base \
  jq rsync \
  geoip-dev expat-dev zlib-dev \
  libressl-dev libressl \
  mariadb-client mariadb-connector-c mariadb-dev \
  nodejs-npm fontconfig

RUN curl -sfLo /usr/bin/cpanm https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm && chmod a+x /usr/bin/cpanm

RUN curl -sfLo /usr/bin/confd \
   https://github.com/kelseyhightower/confd/releases/download/v0.15.0/confd-0.15.0-linux-amd64 && \
   chmod a+x /usr/bin/confd

ADD patch-dbdimp.c /root/

RUN cpanm Devel::CheckLib HTTP::Date LWP::Simple DBI CPAN && rm -fr ~/.cpanm

RUN cpan  < /dev/null ; \
   mkdir -p /tmp/dbd ; cd /tmp/dbd ; \
   cpan -g DBD::mysql ; \
   tar xvzf DBD-mysql*.tar.gz && rm *.tar.gz && cd DBD-mysql* && \
   patch -p0 < /root/patch-dbdimp.c && perl Makefile.PL && make -j2 && make install ; \
   rm -fr ~/.cpan

RUN perl -MDBD::mysql -e ''

ADD perl-modules /tmp/.modules

USER root

# install all the cpan stuff we need
RUN cpanm  DBI DBD::mysql; \
    cpanm < /tmp/.modules; rm -fr ~/.cpanm; rm -fr /usr/local/share/man;

# install csso-cli, uglify-js to minimize css and js; "hulk" to compile js templates
RUN npm config set jobs 1
RUN npm install -g \
  hogan.js gulp-cli source-map-support \
  uglify-js \
  csso csso-cli \
  && chown -R root:root /usr/lib/node_modules && rm -fr ~/.npm

ADD wait-for-it.sh /usr/bin/
ADD geoipupdate-lite /usr/bin/

#RUN go get -u github.com/jwilder/dockerize

RUN /usr/bin/geoipupdate-lite
