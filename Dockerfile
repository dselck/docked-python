FROM        jrottenberg/ffmpeg:latest
ENV         TINI_VERSION v0.18.0
ADD         https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN         chmod +x /tini
ENTRYPOINT  ["/tini", "--"]

RUN         apt-get update --fix-missing && \
            apt-get install -y wget \
                               bzip2 \
                               ca-certificates \
                               libglib2.0-0 \
                               libxext6 \
                               libsm6 \
                               libxrender1 \
                               git \
                               mercurial \
                               subversion && \
            apt-get -y autoremove && \
            apt-get -y clean && \
            rm -rf /var/lib/apt/lists/*

RUN         wget --quiet https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh -O ~/anaconda.sh && \
            /bin/bash ~/anaconda.sh -b -p /opt/conda && \
            rm ~/anaconda.sh && \
            ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
            echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
            echo "conda activate base" >> ~/.bashrc

RUN         conda install -c conda-forge jupyterlab

VOLUME      /root/.jupyter
VOLUME      /mnt/Videos
EXPOSE      8888
CMD         jupyter lab --port=8888 --no-browser --ip=0.0.0.0 --allow-root