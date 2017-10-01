FROM alpine:3.6

# Cache buster for occasionally resetting the cached images for the yum commands
ENV LAST_UPDATED 2017-10-01

RUN \
  echo @testing http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories; \
  apk update; apk upgrade; \
  apk add confd@testing gosu@testing; \
  apk add curl git \
  perl-dev wget make bash build-base \
  jq rsync \
  geoip-dev expat-dev zlib-dev \
  libressl-dev libressl \
  mariadb-client mariadb-client-libs mariadb-dev \
  nodejs-npm fontconfig

RUN curl -sfLo /usr/bin/cpanm https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm; chmod a+x /usr/bin/cpanm

ADD perl-modules /tmp/.modules

USER root

# install all the cpan stuff we need
RUN cpanm  DBI DBD::mysql; \
    cpanm -n < /tmp/.modules; rm -fr ~/.cpanm; rm -fr /usr/local/share/man;

# install csso-cli, uglify-js to minimize css and js; "hulk" to compile js templates
RUN npm config set jobs 1
RUN npm install -g \
  hogan.js gulp-cli source-map-support \
  uglify-js \
  csso csso-cli \
  && chown -R root:root /usr/lib/node_modules

ADD wait-for-it.sh /usr/bin/
ADD geoipupdate-lite /usr/bin/

#RUN go get -u github.com/jwilder/dockerize

RUN /usr/bin/geoipupdate-lite
