FROM        python:latest
ENV         TINI_VERSION v0.18.0
ENV         JUPYTER_CONFIG_DIR="/root/.jupyter/"
ADD         https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN         chmod +x /tini
ENTRYPOINT  ["/tini", "--"]
RUN         pip install jupyter m3u8 jupyterlab tqdm numpy scipy matplotlib sympy pandas
RUN         apt-get update && \
            apt-get upgrade -y && \
            apt-get install -y ffmpeg && \
            apt-get -y autoremove && \
            apt-get -y clean && \
            rm -rf /var/lib/apt/lists/* && \
            rm -rf /tmp/* && \
            rm -rf /var/tmp/*
WORKDIR     /usr/local/src
VOLUME      /mnt/Videos
EXPOSE      8888
CMD         ["/usr/local/bin/start_jupyter.sh"]
COPY        root/ /