#!/bin/bash
# Putting this in global to get it out there no as Jon is pressing for some immediacy.
# I'll get it patched into the OS layer once I have time or when we get Ubuntu nodes in the mix

# Move yum cache out of ramfs to avoid large updates from filling up /

#using count to make sure one of the two functions are run
count=0


function centos_yum {

	# Move yum cache out of ramfs to avoid large updates from filling up /
	if [ ! -L /var/cache/yum ]; then
    	mkdir -p /mnt/disk1/var/cache/yum
    	rm -rf /var/cache/yum
    	ln -s /mnt/disk1/var/cache/yum /var/cache/
	fi

	# Initial patch to catch nodes at bootup
	# Excluding kernel and IB packages
	# yum update -y --nogpgcheck --exclude=kernel* --exclude=ibutils* --exclude=libmlx* --exclude=infini* --exclude=libsdp* --exclude=libnes* --exclude=openib* --exclude=libib*
	yum clean all

	yum install yum-cron -y --nogpg

	cat >/etc/sysconfig/yum-cron <<-%EOF
	YUM_PARAMETER="-x kernel* -x ibutils* -x libmlx* -x infini* -x libsdp* -x libnes* -x openib* -x libib*"
	CHECK_ONLY=no
	CHECK_FIRST=no
	DOWNLOAD_ONLY=no
	#ERROR_LEVEL=0
	#DEBUG_LEVEL=0
	RANDOMWAIT="60"
	MAILTO=russell.wagneriii@risk.lexisnexis.com
	#SYSTEMNAME="" 
	DAYS_OF_WEEK="1234" 
	CLEANDAY="0123456"
	SERVICE_WAITS=yes
	SERVICE_WAIT_TIME=300
	%EOF
	/etc/init.d/yum-cron start

	# adding chkconfig to support full installs that use genesis for logins/roles
	chkconfig yum-cron on
	let count+=1
}

	

function ubuntu_apt {
	# this is the installer for apt package manager
	
	# does cron-apt already exist? If not, install it.
	if ! [ -f /etc/cron-apt/config ] ; then
	apt-get update && apt-get -y install cron-apt
	fi
	
	#Regarless if it's installed, let's set the following params
	## perform an update with the appitiona param to stay quiet
	echo "update -o quiet=2" > /etc/cron-apt/action.d/0-update
	## clean the apt database, perform a regular upgrade and not a dist-upgrade. This will allow the apt to not upgrade kernel and other conflicting packages.
	echo "autoclean -y
	upgrade -y -o APT::Get::Show-Upgraded=true" > /etc/cron-apt/action.d/3-download

	#delete current cron job
	rm -f /etc/cron.d/cron-apt
	# perform script at 4 AM on Mon, Tues, Wen, Thurs.
	echo "0 4 * * 1-4	root	/usr/sbin/cron-apt" > /etc/cron.d/cron-apt
	#check to see a function has run.
	let count+=1
}



if [ -f /usr/sbin/yum ] ; then centos_yum ; fi
if [ -f /usr/sbin/apt ] ; then ubuntu_apt ; fi
if [ $count == 0 ] ; then echo "neither apt or yum was run, please ensure apt or yum are installed to /usr/bin" && exit 1; fi
if [ $count >= 2 ] ; then echo "both apt and yum ran, what?!" && exit 1; fi
