#!/usr/bin/env bash

# script that will run inside the container after it is build

# initialize shell and activate environment
eval "$(micromamba shell hook --shell bash)"
micromamba activate dev

# install package
pip install -e .
