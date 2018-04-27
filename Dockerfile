FROM        jrottenberg/ffmpeg:latest

ENV         TINI_VERSION v0.18.0
ADD         https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN         chmod +x /tini
ENTRYPOINT  ["/tini", "--"]

ENV         PATH /opt/conda/bin:$PATH
ENV         SHELL /bin/bash
ENV         NB_USER nonroot
ENV         NB_UID 1000
ENV         NB_DIR /home/$NB_USER/notebooks
ENV         PORT 8888
ENV         LC_ALL en_US.UTF-8
ENV         LANG en_US.UTF-8
ENV         LANGUAGE en_US.UTF-8

RUN         apt-get update --fix-missing && \
            apt-get -y uprade && \
            apt-get install -y wget \
                               bzip2 \
                               ca-certificates \
                               curl \
                               git && \
            apt-get -y autoremove && \
            apt-get -y clean && \
            rm -rf /var/lib/apt/lists/*

RUN         adduser -s /bin/bash -u $NB_UID -D $NB_USER && \
            mkdir -p /opt/conda && \
            chown $NB_USER /opt/conda

USER        $NB_USER
RUN         mkdir /home/$NB_USER/.jupter && \
            mkdir /home/$NB_USER/.local && \
            mkdir $NB_DIR

RUN         wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
            /bin/bash ~/miniconda.sh -b -p /opt/conda && \
            rm ~/miniconda.sh && \
            ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
            echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
            echo "conda activate base" >> ~/.bashrc

RUN         /opt/conda/bin/conda install -c conda-forge jupyterlab tqdm pip
RUN         /opt/conda/bin/pip install m3u8

USER        root
VOLUME      /home/$NB_USER/.jupyter
VOLUME      /mnt/Videos
VOLUME      $NB_DIR
WORKDIR     $NB_DIR
EXPOSE      8888
CMD         ["start.sh"]

COPY        start.sh /usr/local/bin/
RUN         chmod +x /usr/local/bin/start.sh

USER $NB_USER