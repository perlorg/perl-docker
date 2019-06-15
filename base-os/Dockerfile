FROM alpine:3.9.4

# Cache buster for occasionally resetting the cached images for the yum commands
ENV LAST_UPDATED 2019-06-15

RUN \
  apk --no-cache update && apk --no-cache upgrade && \
  apk --no-cache add curl git \
  perl-dev wget make bash build-base \
  jq rsync \
  geoip-dev expat-dev zlib-dev \
  openssl-dev openssl \
  mariadb-client mariadb-connector-c mariadb-dev \
  nodejs-npm fontconfig tzdata

RUN \
  echo @testing http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories-test; \
  apk --no-cache --repositories-file /etc/apk/repositories-test add gosu@testing;

RUN curl -sfLo /usr/bin/cpanm https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm && chmod a+x /usr/bin/cpanm

RUN curl -sfLo /usr/bin/confd \
   https://github.com/kelseyhightower/confd/releases/download/v0.15.0/confd-0.15.0-linux-amd64 && \
   chmod a+x /usr/bin/confd

RUN cpanm Devel::CheckLib HTTP::Date LWP::Simple DBI CPAN && rm -fr ~/.cpanm

RUN cpanm -n DBD::mysql && rm -fr ~/.cpanm
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
