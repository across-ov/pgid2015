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
apache="apache2"
shib="shibboleth"
modshib="libapache2-mod-shib2"

read -p "VO name (e.g. across): " name
read -p "IP address (e.g. 200.193.144.3): " ip
read -p "FQDN address (e.g. across.fibre.org.br): " fqdn

#echo $name $ip $fqdn

echo "Updating package list.."
apt-get -qq update  # To get the latest package lists

# check if packages was installed
# Apache2
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $apache|grep "install ok installed")
echo Checking for somelib: $apache was installed
if [ "" == "$PKG_OK" ]; then
  echo "No $apache ... Setting up $apache ..."
  echo "Download and install Apache"
  sudo apt-get --force-yes --yes -qq install $apache
fi
 
# Shibolleth 2.X
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $shib|grep "install ok installed")
echo Checking for somelib: $shib was installed
if [ "" == "$PKG_OK" ]; then
  echo "No $shib ... Setting up $shib ..."
  echo "Download and install Apache"
  sudo apt-get --force-yes --yes -qq install $shib
fi
 
# mod_shib
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $modshib|grep "install ok installed")
echo Checking for somelib: $modshib was installed
if [ "" == "$PKG_OK" ]; then
  echo "No $modshib ... Setting up $modshib ..."
  echo "Download and install Apache"
  sudo apt-get --force-yes --yes -qq install $modshib
fi
 
read -p "Please, inform the file (with full path) of metadata file: " metaov
echo $metaov
#
