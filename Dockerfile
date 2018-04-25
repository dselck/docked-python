FROM        python:latest
ENV         TINI_VERSION v0.18.0
ADD         https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN         chmod +x /tini
ENTRYPOINT  ["/tini", "--"]
RUN         pip install jupyter m3u8 jupyterlab
WORKDIR     /usr/local/src
VOLUME      /mnt/Videos
EXPOSE      8888
CMD         ["Jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0"]