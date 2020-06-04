FROM ubuntu:18.04
ENV container docker
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test

RUN apt-get install -y wget
RUN apt-get install -y libssl-dev openssl
RUN apt-get install -y gcc g++ git
RUN apt-get install -y cmake

# we need newer cmake so build from sources
ARG cmake_ver=3.17.2
RUN cd /opt && wget https://github.com/Kitware/CMake/releases/download/v${cmake_ver}/cmake-${cmake_ver}.tar.gz && tar -zxvf ./cmake-${cmake_ver}.tar.gz
RUN cd /opt && rm ./cmake-${cmake_ver}.tar.gz
RUN cd /opt/cmake-${cmake_ver}  && ./bootstrap
RUN cd /opt/cmake-${cmake_ver}  && make
RUN cd /opt/cmake-${cmake_ver}  && make install


RUN echo '#!/bin/bash'                >entrypoint.sh && \
    echo 'set -e'                    >>entrypoint.sh && \
	echo 'if [[ $# -eq 0 ]] ; then'  >>entrypoint.sh && \
	echo '   exec /bin/sh'           >>entrypoint.sh && \
	echo 'fi'                        >>entrypoint.sh && \
	echo 'exec "$@"'                 >>entrypoint.sh 

RUN chmod +x ./entrypoint.sh

RUN groupadd -g 1001 jenkins && \
     useradd -m -u 1001 -g 1001 -d /home/jenkins -s /bin/sh jenkins &&\
     echo "jenkins:jenkins" | chpasswd
USER jenkins

ARG gitdir=toftof-server
ADD https://api.github.com/repos/zweistein-frm2/${gitdir}/git/refs/heads/master version.json
RUN git clone -b master https://github.com/zweistein-frm2/${gitdir}.git ${gitdir}/


RUN cd ${gitdir} && git submodule init && git submodule update
RUN echo ${gitdir}
ARG targ1=/hiersolleshin
RUN mkdir ${targ1}
RUN cd ${targ1} && cmake -S /${gitdir}/ -B ${targ1} 
RUN cd ${targ1} && make install

USER root
ENTRYPOINT ["/entrypoint.sh"]







