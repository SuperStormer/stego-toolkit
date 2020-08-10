FROM debian:buster-slim as build

ENV DEBIAN_FRONTEND noninteractive
#see https://github.com/debuerreotype/docker-debian-artifacts/issues/24
RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y apt-utils \
                       file \
                       foremost \
                       binwalk \
                       exiftool \
                       outguess \
                       pngtools \
                       pngcheck \
                       git \
                       hexedit \
                       python3-pip \
                       python-pip \
                       libevent-dev \
                       ffmpeg \
                       crunch \
                       cewl \
                       xxd \
                       atomicparsley \
                       wget && \
    pip install tqdm


FROM build AS terminal

COPY install/terminal /tmp/install
RUN chmod a+x /tmp/install/*.sh && \
    for i in /tmp/install/*.sh;do echo $i && $i;done && \
    rm -rf /tmp/install

# Use this section to try new installation scripts.
# All previous steps will be cached
#
# COPY install_dev /tmp/install
# RUN find /tmp/install -name '*.sh' -exec chmod a+x {} + && \
#     for f in $(ls /tmp/install/* | sort );do /bin/sh $f;done && \
#     rm -rf /tmp/install

COPY examples /examples

COPY scripts/terminal /opt/scripts
RUN find /opt/scripts -name '*.sh' -exec chmod a+x {} + && \
    find /opt/scripts -name '*.py' -exec chmod a+x {} +
ENV PATH="/opt/scripts:${PATH}"

WORKDIR /data
CMD ["/bin/bash"]

FROM terminal as gui

COPY install/gui /tmp/install
RUN chmod a+x /tmp/install/*.sh && \
    for i in /tmp/install/*.sh;do echo $i && $i;done && \
    rm -rf /tmp/install

COPY scripts/gui /opt/scripts
RUN find /opt/scripts -name '*.sh' -exec chmod a+x {} + && \
    find /opt/scripts -name '*.py' -exec chmod a+x {} +

CMD ["/bin/bash"]
