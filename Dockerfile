FROM        python:alpine
RUN         apk add --no-cache tini
ENTRYPOINT  ["/sbin/tini", "--"]
RUN         pip install jupyter m3u8 jupyterlab
WORKDIR     /usr/local/src
VOLUME      /mnt/Videos
EXPOSE      8888
CMD         ["Jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0"]