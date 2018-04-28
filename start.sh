#!/bin/bash

exec $CONDA_DIR/bin/jupyter lab --port=$PORT --ip=0.0.0.0 --no-browser $*