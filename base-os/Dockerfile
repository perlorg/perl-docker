FROM alpine:3.15.3

# Cache buster for occasionally resetting the cached images for the yum commands
ENV LAST_UPDATED 2022-04-03

RUN \
  apk update && \
  apk -U upgrade --ignore alpine-baselayout && \
  apk add curl git \
  perl-dev wget make bash zsh build-base \
  jq rsync \
  geoip-dev expat-dev zlib-dev \
  openssl-dev openssl \
  mariadb-client mariadb-connector-c mariadb-dev \
  npm yarn \
  fontconfig tzdata su-exec && \
  rm -fr /var/cache/apk && \
  mkdir -p /var/cache/apk

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
