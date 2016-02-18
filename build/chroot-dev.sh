#!/bin/bash
#
# Open Kernel Attached Operating System (OpenKaOS)
# Platform Build System version 5.0.0
#
# Copyright (c) 2009-2016 Opaque Systems, LLC 
#
# script : chroot-fcs.sh
# purpose: manual script to enter chroot for FCS release
#

echo ""
echo "Open Kernel Attached Operating System (OpenKaOS)"
echo "Copyright (c) 2009-2016 Opaque Systems, LLC"
echo ""
echo "Build Environment: $1"
echo ""

echo "  [.] Loading environment "
PBCUR=`cat ~/openkaos/.current`
export PBCUR
PBENV="/home/$USER/openkaos/$PBCUR/$1"
export PBENV
source $PBENV/.env
LFS="$PBWS/$PBTAG/$1/bld/"
export LFS
echo "      Env is $PBENV"
echo "      Build is $LFS"
echo ""

echo " [.] Mounting Virtual File Systems"
sudo mount -v --bind /dev $LFS/dev
sudo mount -vt devpts devpts $LFS/dev/pts
sudo mount -vt tmpfs shm $LFS/dev/shm
sudo mount -vt proc proc $LFS/proc
sudo mount -vt sysfs sysfs $LFS/sys

echo " [.] Moving source code"
sudo mv $LFS/../src2 $LFS/src

echo " [.] Installing latest dev scripts"
sudo mkdir -p $LFS/devtools/
sudo cp *.sh $LFS/devtools/

echo ""
echo " [.] Entering chroot"

sudo chroot "$LFS" /usr/bin/env -i \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h


echo ""
echo " [.] Unmount filesystems"
sudo umount $LFS/dev/pts $LFS/dev/shm $LFS/dev $LFS/proc $LFS/sys
echo " [.] Moving source code"
sudo mv $LFS/src $LFS/../src2
echo " [.] Removing latest dev scripts"
sudo rm -rf $LFS/devtools/


