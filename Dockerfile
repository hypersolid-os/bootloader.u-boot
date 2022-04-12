FROM debian:bullseye

# system base packages + build dependencies
RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends \ 
        nano bash ca-certificates openssh-client \
        subversion g++ zlib1g-dev build-essential git python python3 \
        rsync libncurses5-dev gawk gettext unzip file libssl-dev wget zip time \
        bison flex bc u-boot-tools gcc-aarch64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

# system users+paths
RUN set -xe \
    && useradd build \
    && mkdir /home/build \
    && mkdir /mnt/target /mnt/conf \
    && chmod 0777 /mnt/target \
    && chown build:build /home/build

# copy base fs
COPY fs/ /

# run as build user
USER build

# clone repo
RUN set -xe \
    && cd /home/build \
    && git clone git://git.denx.de/u-boot.git uboot

# checkout stable
ARG GIT_REVISION=v2022.04

# fetch branch/tag and update feeds ~100MB
RUN set -xe \
    && cd /home/build/uboot \
    && git checkout ${GIT_REVISION}

# config
RUN set -xe \
    && echo "source /mnt/conf/build.env" >> ~/.bashrc

# copy related configs
#COPY conf/ /home/build/conf

# working dir
WORKDIR /home/build/uboot

# start bash
ENTRYPOINT [ "/bin/bash" ]