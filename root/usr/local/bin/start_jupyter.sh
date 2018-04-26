#!/bin/sh

# make folder
mkdir -p /root/.jupyter

[[ ! -e /root/.jupyter/jupyter_notebook_config.py ]] && \
    cp /defaults/jupyter_notebook_config.py.bak /root/.jupyter/jupyter_notebook_config.py

jupyter lab --port=8888 --no-browser --ip=0.0.0.0 --allow-root