FROM debian:latest
MAINTAINER Dmitriy Olshevskiy <olshevskiy87@bk.ru>

RUN apt-get update
RUN apt-get -y install \
    git vim sudo \
    flex bison libreadline-dev libkrb5-dev libxml2-dev \
    libxslt1-dev libldap2-dev tcl-dev libperl-dev python-dev \
    libpq-dev

ENV PGGIT /git/pgsql
ENV PGROOT /pgsql
ENV PGDATA ${PGROOT}/data
ENV PGUSER postgres

RUN useradd -m postgres
RUN echo "postgres:postgres" | chpasswd
RUN adduser postgres sudo

RUN mkdir -p ${PGGIT}
RUN chown -R postgres ${PGGIT}
RUN mkdir ${PGROOT}
RUN chown -R postgres ${PGROOT}

USER postgres
ENV HOME /home/postgres

COPY pg.sh ${HOME}/

RUN git clone git://git.postgresql.org/git/postgresql.git ${PGGIT}

WORKDIR ${PGGIT}
RUN ./configure --prefix=${PGROOT}
RUN make
RUN make install

WORKDIR ${PGGIT}/contrib
RUN make
RUN make install

WORKDIR ${HOME}
ENV PATH ${PGROOT}/bin:${PATH}
RUN echo "alias ll='ls -la --color'" > ${HOME}/.bashrc
