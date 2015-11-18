FROM centos:centos6.7
ADD mariadb.repo /etc/yum.repos.d/
RUN yum -y install epel-release; yum -y update; yum clean all
RUN yum -y install perl GeoIP-devel cronolog tar bzip2 gcc patch \
  MariaDB-devel MariaDB-compat MariaDB-client zlib zlib-devel openssl-devel; yum clean all
ENV PERLBREW_ROOT=/perl5
RUN curl -L http://install.perlbrew.pl | bash

ENV PERLBREW_PERL=perl-5.20.3
ENV PATH=/perl5/bin:/perl5/perls/${PERLBREW_PERL}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PERLBREW_MANPATH=/perl5/perls/${PERLBREW_PERL}/man
ENV PERLBREW_PATH=/perl5/bin:/perl5/perls/${PERLBREW_PERL}/bin

RUN /perl5/bin/perlbrew init
RUN /perl5/bin/perlbrew install -j 4 ${PERLBREW_PERL}; perlbrew clean; rm -fr /perl5/perls/perl-*/man
RUN /perl5/bin/perlbrew install-cpanm
RUN /perl5/bin/perlbrew switch ${PERLBREW_PERL}

ENV PERLBREW_SKIP_INIT=1
