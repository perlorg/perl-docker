FROM quay.io/ntppool/base-os

RUN yum install -y npm; yum clean all

ADD perl-modules /tmp/.modules

RUN cpanm  DBI DBD::mysql
RUN cpanm -n LWP::Protocol::https
RUN cpanm -n < /tmp/.modules

RUN npm config set jobs 1
RUN npm install -g hogan.js

RUN rpm -e gcc cpp ppl cloog-ppl gcc-c++ MariaDB-devel libstdc++-devel \
   npm node-gyp

RUN rpm -qa --queryformat '%{NAME}\n'  | grep -- '-devel$'  |xargs rpm -e

RUN rm -fr ~/.cpanm

ENV CBROOTLOCAL=/ntppool/
ENV CBROOT=/ntppool/combust
ENV CBCONFIG=/ntppool/combust.docker.conf

VOLUME /ntppool
WORKDIR /ntppool

CMD /bin/bash
