#!/bin/bash

# set the script to fail on first error
set -e

SCRIPT_BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source common environment varianbles
source ${SCRIPT_BASE_DIR}/env.sh

# change working directory to octoprint home
cd ${OCTOPRINT_HOME}

# add current user to required groups
echo "adding user to required groups ..."
sudo usermod -a -G tty ${USER}
sudo usermod -a -G dialout ${USER}

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

echo "Done configuring octoprint"
