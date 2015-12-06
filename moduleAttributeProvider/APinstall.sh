#!/bin/bash

clear

echo "======================================================="
echo " Starting AP Install"
echo "======================================================="
echo "======================================================="
echo "V0.1"
echo "PGID 2015"
echo "======================================================="
echo "======================================================="
echo "Info: This wizard will guide you to configure"
echo "your Attribute Provider Module"
echo "step: APInstall." 
echo "Please, complete all requests with non-capital letters."
echo "***********************************"
echo "***********************************"
echo "Warning! Run as root or using sudo."
echo "***********************************"
echo "***********************************"

# Start AP Install

# Install LDAP
ldap="slapd ldap-utils"

echo "Updating package list.."
#apt-get -qq update  # To get the latest package lists


# check if packages was installed
# slapd and ldap-utils
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $slapd|grep "install ok installed")
echo Checking for somelib: $slapd was installed
if [ "" == "$PKG_OK" ]; then
  echo "No $slapd ... Setting up $slapd ..."
  echo "Download and install Apache"
  sudo apt-get --force-yes --yes -qq install $apache
fi

# Configure LDAP
echo "VO name (e.g. across) - Max 6 characters: " 
read -n6 organization
echo ""

echo "LDAP manager (cn=Manager,dc=$organization,dc=across) password: "
read -s passwd

# Converting to LDAP hash format
password="$(slappasswd -s $passwd)"

# replacing / to \/ for sed replaces
password=${password/\//\\/}
#echo $password


echo ""
user="cn=Manager,dc=$organization,dc=across"

# Creating attributes
# reserved OID for experimental attributes 1.3.6.1.4.1.4203.666.XXX
# RFC 4517
#	Syntax                           OBJECT IDENTIFIER
#      ==============================================================
#      Attribute Type Description       1.3.6.1.4.1.1466.115.121.1.3
#      Bit String                       1.3.6.1.4.1.1466.115.121.1.6
########### Selected
#      Boolean                          1.3.6.1.4.1.1466.115.121.1.7
#      Country String                   1.3.6.1.4.1.1466.115.121.1.11
#      Delivery Method                  1.3.6.1.4.1.1466.115.121.1.14
########### Selected
#      Directory String                 1.3.6.1.4.1.1466.115.121.1.15
#      DIT Content Rule Description     1.3.6.1.4.1.1466.115.121.1.16
#      DIT Structure Rule Description   1.3.6.1.4.1.1466.115.121.1.17
#      DN                               1.3.6.1.4.1.1466.115.121.1.12
#      Enhanced Guide                   1.3.6.1.4.1.1466.115.121.1.21
#      Facsimile Telephone Number       1.3.6.1.4.1.1466.115.121.1.22
#      Fax                              1.3.6.1.4.1.1466.115.121.1.23
#      Generalized Time                 1.3.6.1.4.1.1466.115.121.1.24
#      Guide                            1.3.6.1.4.1.1466.115.121.1.25
#      IA5 String                       1.3.6.1.4.1.1466.115.121.1.26
########## Selected
#      Integer                          1.3.6.1.4.1.1466.115.121.1.27
#      JPEG                             1.3.6.1.4.1.1466.115.121.1.28
#      LDAP Syntax Description          1.3.6.1.4.1.1466.115.121.1.54
#      Matching Rule Description        1.3.6.1.4.1.1466.115.121.1.30
#      Matching Rule Use Description    1.3.6.1.4.1.1466.115.121.1.31
#      Name And Optional UID            1.3.6.1.4.1.1466.115.121.1.34
#      Name Form Description            1.3.6.1.4.1.1466.115.121.1.35
#      Numeric String                   1.3.6.1.4.1.1466.115.121.1.36
#      Object Class Description         1.3.6.1.4.1.1466.115.121.1.37
#      Octet String                     1.3.6.1.4.1.1466.115.121.1.40
#      OID                              1.3.6.1.4.1.1466.115.121.1.38
#      Other Mailbox                    1.3.6.1.4.1.1466.115.121.1.39
#      Postal Address                   1.3.6.1.4.1.1466.115.121.1.41
#      Printable String                 1.3.6.1.4.1.1466.115.121.1.44
#      Substring Assertion              1.3.6.1.4.1.1466.115.121.1.58
#      Telephone Number                 1.3.6.1.4.1.1466.115.121.1.50
#      Teletex Terminal Identifier      1.3.6.1.4.1.1466.115.121.1.51
#      Telex Number                     1.3.6.1.4.1.1466.115.121.1.52
#      UTC Time                         1.3.6.1.4.1.1466.115.121.1.53

# store VO attributes

echo "========================================"
echo ""
read -p "Please, inform how many attributes will be registered: " nofattr

schema="files/across.schema"

echo "# VO attributes schema from $organization" > $schema
        COUNTER=1

        while [  $COUNTER -le $nofattr ]; do
		echo ""
                echo "******* Setting attribute number $COUNTER ********"
		echo ""
                read -p "Attribute name: " attrname[$COUNTER]
                read -p "Attribute description: " attrdesc
                echo "Select Attribute type "
                        echo "1) String"
                        echo "2) Integer"
                        echo "3) Boolean"
                read -p "Option number -> " opt
                        case $opt in
                                '1')
                                        echo "attributetype (1.3.6.1.4.1.4203.666.$COUNTER" >> $schema
                                        echo "  NAME ('${attrname[$COUNTER]}')" >> $schema
                                        echo "  DESC '$attrdesc'" >> $schema
                                        echo "  SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )" >> $schema
                                        ;;
                                '2')
                                        echo "attributetype (1.3.6.1.4.1.4203.666.$COUNTER" >> $schema
                                        echo "  NAME ('${attrname[$COUNTER]}')" >> $schema
                                        echo "  DESC '$attrdesc'" >> $schema
                                        echo "  SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )" >> $schema
                                        ;;
                                '3')
                                        echo "attributetype (1.3.6.1.4.1.4203.666.$COUNTER" >> $schema
                                        echo "  NAME ('${attrname[$COUNTER]}')" >> $schema
                                        echo "  DESC '$attrdesc'" >> $schema
                                        echo "  SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 )" >> $schema
                                        ;;
                                *) echo invalid option;;
                        esac
                let COUNTER=COUNTER+1
         done

echo "# --------------------------------------" >> $schema
echo "# ObjectClasses" >> $schema
echo "# --------------------------------------" >> $schema
echo "objectClass (1.3.6.1.4.1.4203.666.1.100 NAME 'across'" >> $schema
echo "	DESC 'Across schema from $organization'" >> $schema
#echo "	SUP 'top'" >> $schema
echo "	AUXILIARY" >> $schema
listattr="	MAY ("
        COUNTER=1
        while [  $COUNTER -le $nofattr ]; do
		 listattr="$listattr ${attrname[$COUNTER]}"
			if [ $COUNTER -lt $nofattr ]
			then
				listattr="$listattr $"
			fi
		let COUNTER=COUNTER+1
	done
echo "$listattr ) )" >> $schema
#echo ")" >> $schema

########################### schema created ################
########################### create sladp.conf ############

echo ""
echo "================ Setting slapd.conf ================="
echo ""
echo "Stoping LDAP daemon, slapd."
service slapd stop

echo "Cleaning database at /var/lib/ldap..."
rm -fr /var/lib/ldap/*

echo "Moving /etc/ldap/slapd.d to slapd.d.old"
mv /etc/ldap/slapd.d /etc/ldap/slapd.d.old 

echo "Creating file /var/lib/ldap/DB_CONFIG"
cp files/DB_CONFIG.template files/DB_CONFIG.$organization
cp files/DB_CONFIG.$organization /var/lib/ldap/DB_CONFIG

echo "Gerando arquivos de configuração..."
cp files/slapd.conf.template files/slapd.conf.$organization

slapd="files/slapd.conf.$organization"
#sed -i "s/"\$ID"/${ID}/g" $slapd
sed -i "s/"\$password"/${password}/g" $slapd
sed -i "s/"\$organization"/${organization}/g" $slapd

# Copying to correct LDAP directory
cp $slapd /etc/ldap/slapd.conf

# Populate LDAP base
echo ""
echo "Populating LDAP base from dc=$organization,dc=across"
cp files/base.ldif.template files/base.ldif.$organization

base="files/base.ldif.$organization"
sed -i "s/"\$organization"/${organization}/g" $base
sed -i "s/"\$password"/${password}/g" $base

slapadd -b "dc=across" -v -l $base

# copy new VO schema
cp $schema /etc/ldap/schema/

echo "Fix permission of /var/lib/ldap/"
chown -R openldap /var/lib/ldap/

echo "Starting slapd again..."
service slapd start

# Validate AP Configuration

echo "*******************************************"
echo "Validating Install and Configuration..."

ldapsearch -D "cn=Manager,dc=$organization,dc=across" -x -w $password -b dc=across -s sub "objectclass=*"

# End
