FROM        python:latest
ENV         TINI_VERSION v0.18.0
ENV         JUPYTER_CONFIG_DIR="/root/.jupyter/"
ADD         https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN         chmod +x /tini
ENTRYPOINT  ["/tini", "--"]
RUN         pip install jupyter m3u8 jupyterlab tqdm
WORKDIR     /usr/local/src
VOLUME      /mnt/Videos
EXPOSE      8888
CMD         ["jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
COPY        start-jupyterlab.sh /usr/local/bin