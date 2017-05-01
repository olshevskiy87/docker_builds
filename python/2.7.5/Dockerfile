FROM centos:6
MAINTAINER Dmitriy Olshevskiy <olshevskiy87@bk.ru>
LABEL Description="This image is used to build python 2.7.5 on Centos 6"

RUN yum -y update && \
    yum -y --nogpgcheck install \
        gcc zlib-devel bzip2-devel openssl-devel libffi-devel

ENV PY_VER 2.7.5

ENV PY_BUILDDIR /opt/python
ENV PYDOWNLOADS /root/downloads
RUN mkdir -p ${PY_BUILDDIR} && mkdir -p ${PYDOWNLOADS}

WORKDIR ${PYDOWNLOADS}

# get python sources
ENV PYFNAME Python-${PY_VER}
RUN curl -O https://www.python.org/ftp/python/${PY_VER}/${PYFNAME}.tgz
RUN tar -xf ${PYFNAME}.tgz

# get pip
RUN curl -O https://bootstrap.pypa.io/get-pip.py

# compile python binaries
WORKDIR ${PYDOWNLOADS}/${PYFNAME}
RUN ./configure --prefix=${PY_BUILDDIR} LDFLAGS="-Wl,-rpath /usr/local/lib"
RUN make && make install

ENV PATH ${PY_BUILDDIR}/bin:${PATH}

# install pip and virtualenv
RUN python ${PYDOWNLOADS}/get-pip.py
RUN pip install -U pip
RUN pip install pyopenssl ndg-httpsclient pyasn1 \
                virtualenv

# do not create .pyc files
ENV PYTHONDONTWRITEBYTECODE 1
