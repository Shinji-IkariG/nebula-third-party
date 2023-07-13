FROM ubuntu:23.04
SHELL ["/bin/bash", "-c"]
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -y make \
                       git \
                       m4 \
                       wget \
                       unzip \
                       xz-utils \
                       patch \
                       python2 \
                       curl \
                       python2-dev \
                       lsb-core \
                       zlib1g-dev \
                       build-essential \
                       libreadline-dev \
                       libncurses-dev \
                       build-essential \
                       cmake \
                       libtool \
                       automake \
                       autoconf \
                       autoconf-archive \
                       autotools-dev \
                       bison \
                       flex \
                       gperf \
                       gettext \
		       ninja-build \
		       libdwarf-dev

ENV PACKAGE_DIR=/usr/src/third-party
RUN mkdir -p ${PACKAGE_DIR}
WORKDIR ${PACKAGE_DIR}
