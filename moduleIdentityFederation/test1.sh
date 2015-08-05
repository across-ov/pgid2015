#!/bin/bash
read -p "IP: " $ip
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
opensslcnf="tmp/files/openssl.cnf"
sed -i "s/"\$INSTITUTION"/${INSTITUTION}/g" $opensslcnf
