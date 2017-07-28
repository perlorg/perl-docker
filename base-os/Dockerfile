FROM alpine:3.6

# Cache buster for occasionally resetting the cached images for the yum commands
ENV LAST_UPDATED 2017-07-27

RUN \
  echo @testing http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories; \
  apk update; apk upgrade; \
  apk add confd@testing gosu@testing; \
  apk add curl git \
  perl-dev wget make bash build-base \
  jq \
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

# install "hulk" to compile the admin templates
RUN npm config set jobs 1
RUN npm install -g \
  hogan.js gulp-cli source-map-support \
  uglify-js \
  csso csso-cli \
  && chown -R root:root /usr/lib/node_modules

# phantomjs for making .png graph images
RUN cd /usr/local; curl -Lo /tmp/phantomjs.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2; tar -xvjf /tmp/phantomjs.bz2; mv phantomjs-2.1.1-linux-x86_64 phantomjs; rm /tmp/phantomjs.bz2

ADD wait-for-it.sh /usr/bin/
ADD geoipupdate-lite /usr/bin/

#RUN go get -u github.com/jwilder/dockerize

RUN /usr/bin/geoipupdate-lite

ENV CBROOTLOCAL=/ntppool/
ENV CBROOT=/ntppool/combust

WORKDIR /ntppool

RUN addgroup ntppool && adduser -D -G ntppool ntppool

USER ntppool

EXPOSE 8299

USER ntppool

#CMD ./docker-run
