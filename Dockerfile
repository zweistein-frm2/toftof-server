FROM ubuntu:18.04
ENV container docker
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test

RUN apt-get install -y libssl-dev openssl
RUN apt-get install -y gcc g++
RUN apt-get install -y cmake

ARG gitdir=toftof-server

ADD https://api.github.com/repos/zweistein-frm2/${gitdir}/git/refs/heads/master version.json
RUN git clone -b master https://github.com/zweistein-frm2/${gitdir}.git ${gitdir}/


RUN cd ${gitdir} && git submodule init && git submodule update
ARG targ1=/hiersolleshin
RUN mkdir ${targ1}
RUN echo ${targ1}
RUN cd ${targ1} && cmake -S /${gitdir}/ -B ${targ1} 
RUN cd ${targ1} && make install






