#!/bin/bash

echo "========================="
echo " Starting VO Install"
echo "========================="
echo "========================="
echo "V0.1"
echo "PGID 2015"
echo "========================="
echo "========================="
echo "Info: This wizard will guide you to configure your Identity Federation Module. Please, complete all requests with non-capital letters."
echo "Run as root or using sudo."

# name of pkgs
$apache = "apache2"
$shib = "shibboleth"
$modshib = "libapache2-mod-shib2"

echo "Updating package list"
apt-get update  # To get the latest package lists

echo "Download and install Apache"
apt-get install $apache -y
echo "Download and install Shibboleth 2.X"
apt-get install $apache -y
echo "Download and enabling mod_shib (Apache)"
apt-get install $modshib -y
a2enmod shib2

echo "Please, inform the file (with full path) of metadata file:"
#
