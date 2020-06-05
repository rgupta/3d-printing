#!/bin/bash

# set the script to fail on first error
set -e

SCRIPT_BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source common environment varianbles
source ${SCRIPT_BASE_DIR}/env.sh

# ensure that required directories exist
mkdir -p ${OCTOPRINT_HOME}
mkdir -p ${OCTOPRINT_DATA_DIR}

# change working directory to octoprint home
cd ${OCTOPRINT_HOME}

# install packages for octoprint
echo "installing packages for octoprint ..."
sudo apt-get update
sudo apt-get -y install \
    python3-pip \
    python3-dev \
    python3-setuptools \
    python3-virtualenv \
    libyaml-dev \
    build-essential \
    git

# create virtual environment
echo "creating virtual environment ..."
virtualenv --python=/usr/bin/python3 venv3

# update venv link
echo "updating link to virtual environment ..."
ln -s venv3 venv

# make the python virtual environment active
source venv/bin/activate

# install octoprint package
echo "installing octoprint package ..."
pip3 install pip --upgrade
pip3 install octoprint

# configure octoprint
echo "configuring octoprint ..."
bash ${SCRIPT_BASE_DIR}/configure-octoprint.sh

echo "Done installing octoprint"
