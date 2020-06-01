#!/bin/bash

# base directory for all octorpint code and scripts
OCTOPRINT_HOME=${HOME}/octoprint

# octoprint data directory
OCTOPRINT_DATA_DIR=${OCTOPRINT_HOME}/data

# ensure that required directories exist
mkdir -p ${OCTOPRINT_HOME}
mkdir -p ${OCTOPRINT_DATA_DIR}

# change working directory to octoprint home
cd ${OCTOPRINT_HOME}

# install packages for octoprint
echo "installing packages for octoprint ..."
sudo apt-get -y install \
    python3-pip \
    python3-dev \
    python3-setuptools \
    python3-virtualenv \
    libyaml-dev \
    build-essential \
    git

# add current user to required groups
echo "adding user to required groups ..."
sudo usermod -a -G tty ${USER}
sudo usermod -a -G dialout ${USER}

# create virtual environment
echo "creating virtual environment ..."
virtualenv --python=/usr/bin/python3 venv3

# make the python virtual environment active
source venv/bin/activate

# update venv link
echo "updating link to virtual environment ..."
ln -s venv3 venv

# install octoprint package
echo "updating link to virtual environment ..."
pip3 install pip --upgrade
pip3 install octoprint

# downloading service startup scripts
wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.init
wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.default

# update octoprint.default script to match local environment
echo "updating octoprint daemon defaults ..."
sed -i "s|pi|${USER}|g" octoprint.default

sed -i "s|#BASEDIR|BASEDIR|g" octoprint.default
sed -i "s|BASEDIR=.*|BASEDIR=${OCTOPRINT_DATA_DIR}|g" octoprint.default

sed -i "s|#CONFIGFILE|CONFIGFILE|g" octoprint.default
sed -i "s|=.*/config|=${OCTOPRINT_DATA_DIR}/config|g" octoprint.default

sed -i "s|#DAEMON=/home/${USER}/OctoPrint|DAEMON=${OCTOPRINT_HOME}|g" octoprint.default

# configure octoprint to load on startup
echo "configuring octoprint to start on boot ..."
sudo mv octoprint.default /etc/default/octoprint
sudo mv octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo update-rc.d octoprint defaults

echo "Done installing octoprint"
