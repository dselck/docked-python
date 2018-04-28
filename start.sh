#!/bin/bash

exec $CONDA_DIR/bin/jupyter lab --port=$NB_PORT --no-browser --ip=0.0.0.0 $*