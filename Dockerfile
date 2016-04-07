FROM debian:latest
MAINTAINER Dmitriy Olshevskiy <olshevskiy87@bk.ru>

RUN apt-get update
RUN apt-get -y install \
    git vim \
    flex bison libreadline-dev libkrb5-dev libxml2-dev \
    libxslt1-dev libldap2-dev tcl-dev libperl-dev python-dev

RUN mkdir /git
RUN git clone git://git.postgresql.org/git/postgresql.git /git/postgresql

WORKDIR /git/postgresql
RUN ./configure
RUN make
RUN make install

WORKDIR /git/postgresql/contrib
RUN make
RUN make install
