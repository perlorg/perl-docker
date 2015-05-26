FROM quay.io/ntppool/base-os

# npm for hulk (hogan.js)
# git and which to start the combust app
RUN yum install -y npm git which; yum clean all

ADD perl-modules /tmp/.modules

# install all the cpan stuff we need
RUN cpanm  DBI DBD::mysql; rm -fr ~/.cpanm
RUN cpanm -n < /tmp/.modules; rm -fr ~/.cpanm

# install "hulk" to compile the admin templates
RUN npm config set jobs 1
RUN npm install -g hogan.js

# cleanup rpm's we don't need in production 
RUN rpm -e gcc cpp ppl cloog-ppl gcc-c++ MariaDB-devel libstdc++-devel \
   npm node-gyp

RUN rpm -qa --queryformat '%{NAME}\n'  | grep -- '-devel$'  |xargs rpm -e

ENV CBROOTLOCAL=/ntppool/
ENV CBROOT=/ntppool/combust
ENV CBCONFIG=/ntppool/combust.docker.conf

VOLUME /ntppool
WORKDIR /ntppool

EXPOSE 8299

CMD /bin/bash
