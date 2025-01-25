FROM debian:bullseye-20230109-slim

MAINTAINER codyc1515
LABEL Description="Pagermon RTL-SDR support"
LABEL Vendor="codyc1515"
LABEL Version="1.0.0"

RUN apt-get update \
&& apt-get install -y --no-install-recommends qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libpulse-dev libx11-dev nodejs npm git libusb-1.0-0-dev pkg-config ca-certificates git-core cmake build-essential \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN mkdir -p /etc/modprobe.d
RUN echo 'blacklist dvb_usb_rtl28xxu' > /etc/modprobe.d/dvb-blacklist.conf
RUN git clone git://git.osmocom.org/rtl-sdr.git
RUN mkdir /tmp/rtl-sdr/build

WORKDIR /tmp/rtl-sdr/build
RUN cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON
RUN make
RUN make install
RUN ldconfig -v

WORKDIR /tmp
RUN rm -rf /tmp/rtl-sdr

WORKDIR /

RUN ldconfig

RUN git clone --depth 1 --progress https://github.com/EliasOenal/multimon-ng.git /tmp/multimon-ng

RUN mkdir /tmp/multimon-ng/build

WORKDIR /tmp/multimon-ng/build
RUN qmake ../multimon-ng.pro PREFIX=/usr/local
RUN make
RUN make install

RUN git clone --progress https://github.com/pagermon/pagermon.git /pagermon

WORKDIR /pagermon/client
RUN npm install

#COPY ./client_config.json /pagermon/client/config/default.json

COPY ./run.sh /
RUN chmod 777 /run.sh

COPY ./healthcheck.js /pagermon/client/healthcheck.js
RUN chmod 777 /pagermon/client/healthcheck.js

CMD ["/run.sh"]

HEALTHCHECK --interval=90s --timeout=30s --start-period=15s --retries=3 CMD node healthcheck.js || exit 1
