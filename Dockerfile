FROM        ubuntu:latest
ENV         TINI_VERSION v0.18.0
ENV         JUPYTER_CONFIG_DIR="/root/.jupyter/"
ADD         https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN         chmod +x /tini
ENTRYPOINT  ["/tini", "--"]
RUN         apt-get update && \
            apt-get upgrade -y && \
            apt-get install -y ffmpeg \
                               python3 \
                               python3-pip && \
            apt-get -y autoremove && \
            apt-get -y clean && \
            rm -rf /var/lib/apt/lists/* && \
            rm -rf /tmp/* && \
            rm -rf /var/tmp/*
RUN         pip3 install jupyter m3u8 jupyterlab tqdm numpy scipy matplotlib sympy pandas
COPY        root/ /
RUN         chmod +x /usr/local/bin/start_jupyter.sh
WORKDIR     /usr/local/src
VOLUME      /mnt/Videos
EXPOSE      8888
CMD         ["/usr/local/bin/start_jupyter.sh"]