#!/bin/bash

exec $CONDA_DIR/bin/jupyter lab --port=8888 --ip=0.0.0.0 --no-browser $*