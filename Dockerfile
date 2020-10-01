FROM debian:stable

RUN apt update && apt upgrade -y && \
    apt install -y g++-arm-linux-gnueabihf build-essential git debootstrap u-boot-tools \
    device-tree-compiler swig python-dev device-tree-compiler bison libncurses-dev flex \
    python3 python3-pip

WORKDIR /tmp

ADD scripts/build_u-boot.sh /tmp
RUN git clone git://git.denx.de/u-boot.git && bash /tmp/build_u-boot.sh

VOLUME /data


CMD /bin/cp /tmp/u-boot/*.bin /data/

