FROM        jrottenberg/ffmpeg:latest
ENV         TINI_VERSION v0.18.0
ADD         https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN         chmod +x /tini
ENTRYPOINT  ["/tini", "--"]

RUN         apt-get update --fix-missing && \
            apt-get install -y wget \
                               bzip2 \
                               ca-certificates \
                               curl \
                               git && \
            apt-get -y autoremove && \
            apt-get -y clean && \
            rm -rf /var/lib/apt/lists/*

RUN         wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
            /bin/bash ~/miniconda.sh -b -p /opt/conda && \
            rm ~/miniconda.sh && \
            ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
            echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
            echo "conda activate base" >> ~/.bashrc

RUN         /opt/conda/bin/conda install -c conda-forge jupyterlab tqdm pip
RUN         /opt/conda/bin/pip install m3u8

VOLUME      /root/.jupyter
VOLUME      /mnt/Videos
EXPOSE      8888
CMD         /opt/conda/bin/jupyter lab --port=8888 --no-browser --ip=0.0.0.0 --allow-root