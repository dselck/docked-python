FROM        jrottenberg/ffmpeg:alpine

RUN         apk --update  --repository http://dl-4.alpinelinux.org/alpine/edge/community add \
            bash \
            git \
            curl \
            ca-certificates \
            bzip2 \
            unzip \
            sudo \
            libstdc++ \
            glib \
            libxext \
            libxrender \
            tini@testing \ 
            && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk" -o /tmp/glibc.apk \
            && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.25-r0/glibc-bin-2.25-r0.apk" -o /tmp/glibc-bin.apk \
            && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk" -o /tmp/glibc-i18n.apk \
            && apk add --allow-untrusted /tmp/glibc*.apk \
            && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
            && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
            && rm -rf /tmp/glibc*apk /var/cache/apk/*

ENV         CONDA_DIR=/opt/conda
ENV         PATH=$CONDA_DIR/bin:$PATH SHELL=/bin/bash LANG=C.UTF-8

RUN         mkdir -p $CONDA_DIR && \
            echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh && \
            curl https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o mconda.sh && \
            /bin/bash mconda.sh -f -b -p $CONDA_DIR && \
            rm mconda.sh

RUN         $CONDA_DIR/bin/conda install -c conda-forge jupyterlab tqdm pip
RUN         $CONDA_DIR/bin/pip install m3u8

ENTRYPOINT  ["/sbin/tini", "--"]
VOLUME      /root/.jupyter
VOLUME      /mnt/Videos
EXPOSE      8888
CMD         /opt/conda/bin/jupyter lab --port=8888 --no-browser --ip=0.0.0.0 --allow-root