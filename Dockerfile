FROM jrottenberg/ffmpeg:latest

USER root

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade && \
    apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*
    
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
    
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini
ENTRYPOINT ["/usr/local/bin/tini", "--"]

ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=nonroot \
    NB_UID=1000 \
    NB_GID=100 \
    NB_PORT=8888 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER
    
ADD fix-permissions /usr/local/bin/fix-permissions

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER:$NB_GID $CONDA_DIR && \
    chmod g+w /etc/passwd /etc/group && \
    /usr/local/bin/fix-permissions $HOME && \
    /usr/local/bin/fix-permissions $CONDA_DIR

USER $NB_UID

RUN mkdir $HOME/notebooks && \
    mkdir $HOME/.jupyter && \
    mkdir $HOME/.local && \
    fix-permissions $HOME
    
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/miniconda.sh && \
    /bin/bash $HOME/miniconda.sh -f -b -p $CONDA_DIR && \
    rm $HOME/miniconda.sh && \
    ln -s $CONDA_DIR/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    $CONDA_DIR/bin/conda update --all --yes && \
    $CONDA_DIR/bin/conda clean -tipsy && \
    rm -rf $HOME/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions $HOME
    
RUN $CONDA_DIR/bin/conda install -c conda-forge \
    jupyter \
    jupyterlab \
    tqdm \
    pip \
    ipywidgets && \
    $CONDA_DIR/bin/pip install m3u8 && \
    $CONDA_DIR/bin/conda clean -tipsy && \
    $CONDA_DIR/bin/jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf $HOME/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions $HOME
    
USER root

EXPOSE $NB_PORT
WORKDIR $HOME
VOLUME $HOME/.jupyter
VOLUME $HOME/notebooks
VOLUME /mnt
CMD ["start.sh"]

COPY start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

USER $NB_USER
