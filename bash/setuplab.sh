#!/bin/bash

workarea=/workarea/scripts
dhcpdconf=/etc/dhcp/dhcpd.conf
mydhcpdconf=$workarea/dhcpd.conf

if [ -L $dhcpdconf ] ; then
	unlink $dhcpdconf
	ln -s $mydhcpdconf $dhcpdconf
else
	rm -f $dhcpdconf
	ln -s $mydhcpdconf $dhcpdconf
fi

mountp=/mnt/disk1
mountd=/dev/sdc2

if ! mountpoint -q $mountp ; then
	echo "CentOS 7 is not mounted at $mountp"
	echo "Attempting to Mount CentOS 7 at $mountd"
	mount $mountd $mountp
		if ! mountpoint -q $mountp ; then
			echo "Mounting $mountd to $mountp has failed"
			exit 1
		fi
	echo "mount succeded!"
fi

echo "chrooting into $mountp and performing a dracut build"
chroot $mountp dracut -v -m "network nfs base" -f /backup/new.img
echo "coping files and distrubuting them to the system"
cp $mountp/backup/new.img $workarea/new.img
cp $workarea/new.img /tftpboot/test.img

md5_1=$(md5sum $mountp/backup/new.img | cut -d ' ' -f 1) 
md5_1_1=$mountp/backup/new.img
md5_2=$(md5sum 	$workarea/new.img | cut -d ' ' -f 1)
md5_2_1=$workarea/new.img
md5_3=$(md5sum /tftpboot/test.img | cut -d ' ' -f 1)
md5_3_1=/tftpboot/test.img
echo "Testing transaction, do all files match?"
if [ $md5_1 != $md5_2 ] || [ $md5_1 != $md5_3 ] || [ $md5_2 != $md5_3 ] ; then
	echo "MD5 SUMS DO NOT MATCH!"
	echo $md5_1 $md5_1_1
	echo $md5_2 $md5_2_1
	echo $md5_3 $md5_3_1
else
	echo "Test succeeds!"
fi

echo "restarting dhcpd service"
sudo service dhcpd restart
