#!/bin/bash
echo "Installing qooxdoo contrib ..."

source $(dirname $0)/.env

# TODO: if env not defined, set defaults
echo "- script dir: " ${SCRIPT_DIR}
echo "- client dir: " ${CLIENT_DIR}
echo "- fonts dir : " ${FONTS_DIR}

# Installs themes and icon fonts
pushd ${HOME};

echo "qooxdoo and compiler versions"
npm ll qooxdoo-sdk
npm ll qxcompiler

popd


pushd ${CLIENT_DIR};

echo "Updating contributions ..."
qx contrib update

echo "Listing contributions ..."
qx contrib list

echo "Installing contributions (based on information from contrib.json) ..."
qx contrib install

popd
