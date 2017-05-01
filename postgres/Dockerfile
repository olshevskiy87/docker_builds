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

RUN useradd -m postgres && echo "postgres:postgres" | chpasswd && adduser postgres sudo

RUN mkdir -p ${PGGIT} && chown -R postgres ${PGGIT}
RUN mkdir ${PGROOT} && chown -R postgres ${PGROOT}

USER postgres
ENV HOME /home/postgres

COPY pg.sh ${HOME}/

RUN git clone git://git.postgresql.org/git/postgresql.git ${PGGIT}

WORKDIR ${HOME}
ENV PATH ${PGROOT}/bin:${PATH}
RUN echo "alias ll='ls -la --color'" > ${HOME}/.bashrc
