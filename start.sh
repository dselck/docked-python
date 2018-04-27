#!/bin/bash

exec jupyter lab --port=$PORT --no-browser --ip=0.0.0.0 $*