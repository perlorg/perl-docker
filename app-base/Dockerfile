FROM quay.io/ntppool/base-os

# npm for hulk (hogan.js)
# git and which to start the combust app
RUN yum install -y npm which fontconfig; yum clean all

ADD perl-modules /tmp/.modules

# install all the cpan stuff we need
RUN cpanm  DBI DBD::mysql; \
    cpanm -n < /tmp/.modules; rm -fr ~/.cpanm; rm -fr /perl5/perls/perl-*/man

# install "hulk" to compile the admin templates
RUN npm config set jobs 1
RUN npm install -g hogan.js gulp-cli source-map-support

# phantomjs for making .png graph images
RUN cd /usr/local; curl -Lo /tmp/phantomjs.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2; tar -xvjf /tmp/phantomjs.bz2; mv phantomjs-2.1.1-linux-x86_64 phantomjs

ADD wait-for-it.sh /usr/bin/
RUN go get -u github.com/jwilder/dockerize

ENV CBROOTLOCAL=/ntppool/
ENV CBROOT=/ntppool/combust
ENV CBCONFIG=/ntppool/combust.docker.conf

WORKDIR /ntppool

EXPOSE 8299

CMD ./docker-run
