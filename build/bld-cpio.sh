#
# Open Kernel Attached Operating System (OpenKaOS)
# Platform Build System version 4.0.0
#
# Copyright (c) 2009-2015 Opaque Systems, LLC 
#
# script : bld-cpio.sh
# purpose: SDK core build script - generates base cpio filesystem
#

SRC=/src
SDK=/sdk
APPCONFIG=/app/config
APPQ=/app/queue/pkg
APPQUEUE=/app/queue
LOGS=/src/logs
CFLAGS="-O2 -fPIC -pipe"
CXXFLAGS="$CFLAGS"
KAOSCPUS=`cat /proc/cpuinfo | grep processor | wc -l`
export SDK SRC LOGS CFLAGS CXXFLAGS KAOSCPUS APPQ APPCONFIG APPQUEUE
MAKEOPTS="-j$KAOSCPUS"
export MAKEOPTS

mkdir -p $SDK/openkaos.fs
mkdir -p $SDK/openkaos.fs/base
mkdir -p $SDK/openkaos.boot

OKBFS=$SDK/openkaos.fs/base
export OKBFS

mkdir -p $OKBFS/{dev,bin,sbin,usr,lib}
mkdir -p $OKBFS/app
mkdir -p $OKBFS/app/config
ln -sfr $OKBFS/lib $OKBFS/lib64
ln -sfr $OKBFS/bin $OKBFS/usr/bin
ln -sfr $OKBFS/sbin $OKBFS/usr/sbin
ln -sfr $OKBFS/lib $OKBFS/usr/lib
ln -sfr $OKBFS/app/config $OKBFS/etc

mknod $OKBFS/dev/tty c 5 0
mknod $OKBFS/dev/console c 5 1
mknod $OKBFS/dev/tty0 c 4 0
mknod $OKBFS/dev/hvc0 c 229 0
mknod $OKBFS/dev/hvc1 c 229 1
mknod $OKBFS/dev/hvc2 c 229 2
mknod $OKBFS/dev/hvc3 c 229 3
mknod $OKBFS/dev/hvc4 c 229 4
mknod $OKBFS/dev/hvc5 c 229 5
mknod $OKBFS/dev/hvc6 c 229 6
mknod $OKBFS/dev/hvc7 c 229 7
mknod $OKBFS/dev/rtc c 10 135
mknod $OKBFS/dev/rtc0 c 254 0

cp -a /sbin/busybox $OKBFS/sbin/
cp -a /app/queue/openssl/lib/libcrypto.so* $OKBFS/lib/
cp -a /app/queue/openssl/lib/libssl.so* $OKBFS/lib/
cp -a /usr/sbin/sshd $OKBFS/sbin/
cp -a /usr/bin/ssh $OKBFS/bin/
cp -a /usr/bin/ssh-keygen $OKBFS/bin/
cp -a /usr/bin/curl $OKBFS/bin/
cp -a /app/queue/dhcpcd/sbin/dhcpcd $OKBFS/sbin/
cp -a /bin/login $OKBFS/bin/
cp -a /sbin/iptables $OKBFS/sbin/
cp -a /sbin/xtables-multi $OKBFS/sbin/

cp -a /lib/ld-* $OKBFS/lib/
cp -a /lib/libc-* $OKBFS/lib/
cp -a /lib/libc.* $OKBFS/lib/
cp -a /lib/libm-* $OKBFS/lib/
cp -a /lib/libm.* $OKBFS/lib/
cp -a /lib/libutil-* $OKBFS/lib/
cp -a /lib/libutil.* $OKBFS/lib/
cp -a /lib/libz.so.* $OKBFS/lib/
cp -a /lib/libcrypt-* $OKBFS/lib/
cp -a /lib/libcrypt.* $OKBFS/lib/
cp -a /lib/libdl-* $OKBFS/lib/
cp -a /lib/libdl.* $OKBFS/lib/
cp -a /lib/libnsl-* $OKBFS/lib/
cp -a /lib/libnsl.* $OKBFS/lib/
cp -a /lib/libnss_* $OKBFS/lib/
cp -a /lib/libresolv-* $OKBFS/lib/
cp -a /lib/libresolv.* $OKBFS/lib/
cp -a /lib/libblkid.* $OKBFS/lib/
cp -a /lib/libuuid.* $OKBFS/lib/
cp -a /lib/libe2p.* $OKBFS/lib/
cp -a /lib/libpthread-* $OKBFS/lib/
cp -a /lib/libpthread.* $OKBFS/lib/
cp -a /lib/libext2fs.* $OKBFS/lib/
cp -a /lib/libcom_err.* $OKBFS/lib/
cp -a /usr/lib/libpam*.so* $OKBFS/lib/
cp -a /lib/security $OKBFS/lib/
cp -a /usr/lib/libcurl.so* $OKBFS/lib/
cp -a /usr/lib/libip4tc.so* $OKBFS/lib/
cp -a /usr/lib/libip6tc.so* $OKBFS/lib/
cp -a /usr/lib/libxtables.so* $OKBFS/lib/
cp -a /lib/xtables/ $OKBFS/lib/

cp -a /etc/{passwd,shadow,group,mtab,ld.so.conf,ld.so.cache,nsswitch.conf} $OKBFS/app/config
cp -a /usr/share/zoneinfo/UTC $OKBFS/app/config/localtime

cat > $OKBFS/init << EOF
#!/sbin/busybox ash

/sbin/busybox mkdir -p /proc /root /sys /dev/pts /dev/shm /app/config/ssh/keys/ /var/run/
/sbin/busybox mount -vt devpts devpts /dev/pts
/sbin/busybox mount -vt tmpfs shm /dev/shm
/sbin/busybox mount -vt proc proc /proc
/sbin/busybox mount -vt sysfs sysfs /sys
/sbin/busybox mknod /dev/sda b 8 0
/sbin/busybox mknod /dev/sda1 b 8 1
/sbin/busybox mknod /dev/sda2 b 8 2
/sbin/busybox mknod /dev/sda3 b 8 3
/sbin/busybox mknod /dev/sda4 b 8 4
/sbin/busybox mknod /dev/sda5 b 8 5
/sbin/busybox mknod /dev/sda6 b 8 6
/sbin/busybox mknod /dev/sda7 b 8 7
/sbin/busybox mknod /dev/tty1 c 4 1
/sbin/busybox mknod /dev/null c 1 3
/sbin/busybox mknod /dev/random c 1 8
/sbin/busybox mknod /dev/urandom c 1 9
/sbin/busybox mknod /dev/ptmx c 5 2
/sbin/busybox mknod /dev/loop0 b 7 0
/sbin/busybox mknod /dev/loop1 b 7 1
/sbin/busybox mknod /dev/loop2 b 7 2
/sbin/busybox mknod /dev/loop3 b 7 3
/sbin/busybox mknod /dev/loop4 b 7 4
/sbin/busybox mknod /dev/loop5 b 7 5
/sbin/busybox mknod /dev/loop6 b 7 6
/sbin/busybox mknod /dev/loop7 b 7 7
/sbin/busybox mknod /dev/xvda b 202 0
/sbin/busybox mknod /dev/xvdb b 202 16
/sbin/busybox chmod 666 /dev/ptmx
/sbin/busybox chmod 666 /dev/tty
/sbin/busybox chmod 666 /dev/null
/sbin/busybox echo "hvc0" >> /etc/securetty

/sbin/busybox echo ""
/sbin/busybox echo "KaOS version 4.0.0"
/sbin/busybox echo "Copyright (c) 2009-2015 Opaque Systems LLC"
/sbin/busybox echo ""
/sbin/busybox echo "http://www.opaquesystems.com"
/sbin/busybox echo ""

while true
do
 /sbin/busybox ash
 /sbin/busybox getty -L 115200 tty1 -t 90 &
 /sbin/busybox getty -L 115200 hvc0 -t 90 &
 /sbin/busybox busybox sleep 95s
done

/sbin/busybox ash

EOF

chmod 755 $OKBFS/init

cd $OKBFS
rm -rf $SDK/openkaos.boot/OpenKaOS_boot-4.0.0.cpio
find . | cpio --quiet -H newc -o > $SDK/openkaos.boot/OpenKaOS_boot-4.0.0.cpio

cat > $SDK/tools/regen-initramfs << EOF
#!/bin/bash

SDKNOW=`date +%s`
SDKPWD=`pwd`
export SDKNOW SDKPWD

mv /sdk/openkaos.boot/OpenKaOS_boot-4.0.0.cpio /sdk/openkaos.boot/OpenKaOS_boot-4.0.0.cpio-$SDKNOW
cd /sdk/openkaos.fs/base/
find . | cpio --quiet -H newc -o > /sdk/openkaos.boot/OpenKaOS_boot-4.0.0.cpio
cd $SDKPWD

EOF


