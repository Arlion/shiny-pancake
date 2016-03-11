#!/bin/bash

#Installing deps
if [ -f /usr/bin/yum ] ;then
	echo "proceeding with yum install"
	yum install -y pip python-ldap python-paramiko
fi
if [ -f /usr/bin/apt] ; then
	echo "proceeding with apt-get install"
	apt-get update
	apt-get install -y python-pip python-ldap python-paramiko
fi

pip install radssh

###### Adding defaults
if [ ! -f /etc/radssh_config ]
then
	touch /etc/radssh_config
fi

echo "plugins=/usr/local/share/radssh/plugins" >> /etc/radssh_config
echo "hostkey.verify=ignore" >> /etc/radssh_config

if [ -f /etc/redhat-release ]
then
	echo "adding centos as default user" 
	echo "username=centos" >> /etc/radssh_config
else
	echo "adding ubuntu as default user"
	echo "username=ubuntu" >> /etc/radssh_config
fi

echo "authfile=/usr/local/share/radssh/authfile"
echo "logdir=/tmp/session_%Y%m%d_%H%M%S"

mkdir -p /usr/local/share/radssh/plugins
svn co http://10.173.0.129/repos/scripts/radssh/radssh/LN_plugins



##Ask for pem auth file
function testinput {
	echo -n "What is the path to your pem file (private key file?) FULL PATH /home/ubuntu/internetofthings.pem "
	read input_variable
	echo "You entered: $input_variable"
}

##check if pem auth file exists
while true; do
	testinput

	if [ -f $input_variable ]
	then
		mv $input_variable /usr/local/share/radssh/authfile.pem
		break
	else
		echo "file does not exist"
	fi
done

#add pem file to key file list
echo "keyfile|*|/usr/local/share/authfile.pem
mkdir -p /usr/local/share/radssh/plugins
find ~ -name ldap_check.py | xargs -i -n 1 cp "{}" /usr/local/share/radssh/plugins

