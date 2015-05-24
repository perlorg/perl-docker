FROM ntp-baseos

ADD perl-modules /tmp/.modules

RUN cpanm  DBI DBD::mysql
RUN cpanm -n LWP::Protocol::https
RUN cpanm -n < /tmp/.modules

RUN rpm -e gcc cpp gpgme gnupg2 ppl cloog-ppl

VOLUME /ntppool
WORKDIR /ntppool

CMD /bin/bash
