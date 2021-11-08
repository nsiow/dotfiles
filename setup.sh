#!/usr/bin/env bash

set -ex

# Install make
sudo apt install -y build-essential

# Let make do the rest
make setup
