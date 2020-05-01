FROM alpine:3.11.6 as perlbrew

PERL_VERSION 5.30.2


RUN \
  apk --no-cache update && apk --no-cache upgrade && \
  apk --no-cache add \
    curl git perl patch \
    wget make bash build-base

ENV PERLBREW_ROOT /perl5

RUN curl -L https://install.perlbrew.pl | bash

RUN bash -c "source /perl5/etc/bashrc; perlbrew install perl-${PERL_VERSION}"

FROM alpine:3.11.6

# Cache buster for occasionally resetting the cached images for the yum commands
ENV LAST_UPDATED 2020-03-01

RUN \
  apk --no-cache update && apk --no-cache upgrade && \
  apk --no-cache add curl git \
  perl-dev wget make bash build-base \
  jq rsync \
  geoip-dev expat-dev zlib-dev \
  openssl-dev openssl \
  mariadb-client mariadb-connector-c mariadb-dev \
  nodejs-npm yarn \
  fontconfig tzdata su-exec

RUN curl -sfLo /usr/bin/cpanm https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm && chmod a+x /usr/bin/cpanm

RUN curl -sfLo /usr/bin/confd \
   https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 && \
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
# https://stackoverflow.com/questions/52196518/could-not-get-uid-gid-when-building-node-docker
RUN npm config set unsafe-perm true
RUN npm install -g \
  hogan.js gulp-cli source-map-support \
  uglify-js \
  csso csso-cli \
  && chown -R root:root /usr/lib/node_modules && rm -fr ~/.npm

ADD wait-for-it.sh /usr/bin/
ADD geoipupdate-lite /usr/bin/

#RUN go get -u github.com/jwilder/dockerize

RUN /usr/bin/geoipupdate-lite
