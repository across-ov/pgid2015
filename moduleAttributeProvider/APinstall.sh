#!/bin/bash

echo "========================="
echo " Starting AP Install"
echo "========================="
echo "========================="
echo "V0.1"
echo "PGID 2015"
echo "========================="
echo "========================="
echo "Info: This wizard will guide you to configure"
echo "your Attribute Provider Module
echo "step: APInstall. 
echo "Please, complete all requests with non-capital letters."
echo "***********************************"
echo "***********************************"
echo "Warning! Run as root or using sudo."
echo "***********************************"
echo "***********************************"

# Start AP Install

# Install LDAP

# Configure LDAP

# Validate AP Configuration

# name of pkgs
apache="apache2"
shib="shibboleth"
modshib="libapache2-mod-shib2"

read -p "VO name (e.g. across): " ovname
read -p "IP address (e.g. 200.193.144.3): " ip
read -p "FQDN address (e.g. across.fibre.org.br): " fqdn

#echo $ovname $ip $fqdn

# create $ovname folder and copy files
mkdir $ovname
cp -r files/ $ovname/

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

##################################
# generate SSL cert
##################################
ed -p "IP: " $ip
echo Please fill the fields
read -p "Institution: " INSTITUTION
read -p "Department: " DEPARTMENT
read -p "email: " EMAIL
read -p "City: " CITY
read -p "State or Province: " STATE
read -p "Country: " COUNTRY
HOST=$ip

echo $INSTITUTION
# edit $ovname/files/openssl.cnf configure and run openssl to generate certs
opensslcnf="$ovname/files/openssl.cnf"
sed -i "s/"\$INSTITUTION"/${INSTITUTION}/g" $opensslcnf
sed -i "s/"\$DEPARTMENT"/${DEPARTMENT}/g" $opensslcnf
sed -i "s/"\$EMAIL"/${EMAIL}/g" $opensslcnf
sed -i "s/"\$CITY"/${CITY}/g" $opensslcnf
sed -i "s/"\$STATE"/${STATE}/g" $opensslcnf
sed -i "s/"\$COUNTRY"/${COUNTRY}/g" $opensslcnf
sed -i "s/"\$HOST"/${HOST}/g" $opensslcnf


echo "File $opensslcnf updated."
echo "Generating OpenSSL certs..."


# metadata federation configure 
read -p "Please, inform the file (with full web address) of metadata file (e.g. https://mmyfederation.across.br/ds/metadata.xml: " metaov
echo $metaov

#
