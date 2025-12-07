
'''
Install Termux, X11, busybox
'''

F0BafyHMmtXDlUqgZ1x89pTrK6o7sEbud

NOPRO_5G122345567888900087777677
#In termux

termux-change-repo
termux-setup-storage

pkg update
pkg upgrade

pkg install x11-repo
pkg install termux-x11-nightly
pkg install tsu

#not runned: pkg install xfce gimp

# copy it to data/local/tmp
cd /data/local/tmp

#get an image of a kali nethuner rootfs from https://kali.download/nethunter-images/current/rootfs/

# eg: https://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-full-amd64.tar.xz

# use fx file explorer or root explorer to copy it to the dir /data/local/kali/

# or run inside termux
pkg install wget
sudo wget #paste the link of the image here

# extract the file, *.xz is a lazy way to extract the file
#make sure you have only one file in here or this cmd will extract all file end with xz
su
tar xpvf *.xz 

# remove file 
rm *.xz

# now the kali will store in /data/local/tmp/kali/chroot/kali-amd64
# because i'm using the amd64 so you must change this
# most device platform is arm64 now

#I'm going to make the path shorter
cd chroot
mv kali-amd64 /data/local/tmp
cd ..
rm -r chroot
mv kali-amd64 kali
exit

# create script to login
cd /data/local/tmp
sudo nano kali.sh

#!/bin/sh
KLPATH="/data/local/tmp/kali"

# Fix setuid issue
mkdir $KLPATH/dev/shm
busybox mount -o remount,dev,suid /data

busybox mount --bind /dev $KLPATH/dev
busybox mount --bind /sys $KLPATH/sys
busybox mount --bind /proc $KLPATH/proc
busybox mount -t devpts devpts $KLPATH/dev/pts 

# /dev/shm for Electron apps
busybox mount -t tmpfs -o size=256M tmpfs $KLPATH/dev/shm

# Mount sdcard
busybox mount --bind /sdcard $KLPATH/sdcard

# chroot into Kali
busybox chroot $KLPATH /bin/su - root



# Ctrl O + Enter + Ctrl X to save and exit

sudo chmod +x kali.sh


# running in kali root
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "127.0.0.1 localhost" > /etc/hosts


groupadd -g 1003 aid_graphics
usermod -g 3003 -G 3003,3004 -a _apt
usermod -G 3003 -a root


apt update
apt upgrade


# create user

ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime

groupadd storage
groupadd wheel
useradd -m -g users -G wheel,audio,video,storage,inet -s /bin/bash user
passwd user


nano /etc/sudoers

# add
user    ALL=(ALL:ALL) ALL

# Ctrl O + Enter + Ctrl X to save and exit

# Switch to user
su user
cd ~

sudo apt install locales
sudo locale-gen en_US.UTF-8



# create new termux session
cd ~
# create a script to auto start
nano kl.sh


#!/bin/bash

# Kill all old prcoesses
killall -9 termux-x11 Xwayland pulseaudio virgl_test_server_android termux-wake-lock
pkill -f com.termux.x11


## Start Termux X11
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity

sudo busybox mount --bind $PREFIX/tmp /data/local/tmp/kali/tmp

export TMPDIR=/data/local/kali/tmp
export XDG_RUNTIME_DIR=${TMPDIR}

termux-x11 :0 -ac &



chmod +x kl.sh



# back to kali 
exit # go as root
cd /tmp
chmod 0777 .X0-lock
chmod 0777 /tmp

su user
cd ~


export DISPLAY=:0
export PULSE_SERVER=tcp:127.0.0.1:4713
startxfce4 &


#make one time script

nano kl.sh

# add this line to end 
su -c "sh /data/local/tmp/kali.sh"

#
sudo nano /data/local/tmp/kali.sh

#comment line 
#busybox chroot $KLPATH /bin/su - root
# change to:

busybox chroot $KLPATH /bin/su - user -c "pkill xfce4-session & export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1:4713 && dbus-launch --exit-with-session startxfce4"

# run only
sh kl.sh


# edit .profile add a script to it
#############################################################################





#!/bin/bash

# Kill all old prcoesses
killall -9 termux-x11 Xwayland pulseaudio virgl_test_server_android termux-wake-lock
pkill -f com.termux.x11

## Start Termux X11
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity

setenforce 0
export TMPDIR=/data/local/tmp/kali/tmp
export CLASSPATH=$(/system/bin/pm path com.termux.x11 | cut -d: -f2)
export XKB_CONFIG_ROOT=/data/local/tmp/kali/usr/share/X11/xkb
/system/bin/app_process / com.termux.x11.CmdEntryPoint :1

termux-x11 :1 -ac &

sleep 3

# Start Pulse Audio of Termux
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

# Start virgl server
virgl_test_server_android &

# Execute chroot Ubuntu script
su -c "sh /data/local/tmp/startu.sh"


//

export DISPLAY=:1

termux-x11 :1 >/dev/null &



# Linking is unneeded since we could just directly modify TMPDIR
# If you you link, make sure to set the owner id to termux's using chown
#ln -s /data/local/nhsystem/kalifs/tmp /data/data/com.termux/files/usr/tmp

# Kill any existing processes
/system/bin/killall -9 app_process termux-x11 Xwayland pulseaudio virgl_test_server_android termux-wake-lock

export XKB_CONFIG_ROOT=/data/local/kali/usr/share/X11/xkb
export TMPDIR=/data/local/kali/tmp
export XDG_RUNTIME_DIR=${TMPDIR}

termux-x11 :1 -ac &

am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity


#!/bin/sh

# The path of Ubuntu rootfs

UBUNTUPATH="/data/local/tmp/ubuntu"

# Fix setuid issue
busybox mount -o remount,dev,suid /data

busybox mount --bind /dev $UBUNTUPATH/dev
busybox mount --bind /sys $UBUNTUPATH/sys
busybox mount --bind /proc $UBUNTUPATH/proc
busybox mount -t devpts devpts $UBUNTUPATH/dev/pts 

# /dev/shm for Electron apps
busybox mount -t tmpfs -o size=256M tmpfs $UBUNTUPATH/dev/shm

# Mount sdcard
busybox mount --bind /sdcard $UBUNTUPATH/sdcard

# chroot into Ubuntu
busybox chroot $UBUNTUPATH /bin/su - root
 

#!/system/bin/sh

export USER=u0_a485 #run whoami in termux

### Setup env ###

export SHELL=/data/data/com.termux/files/usr/bin/bash
export LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec.so
export BOOTCLASSPATH=/apex/com.android.art/javalib/core-oj.jar:/apex/com.android.art/javalib/core-libart.jar:/apex/com.android.art/javalib/okhttp.jar:/apex/com.android.art/javalib/bouncycastle.jar:/apex/com.android.art/javalib/apache-xml.jar:/system/framework/framework.jar:/syst>export PATH=/data/data/com.termux/files/usr/bin
export TMPDIR=/data/local/tmp/kali/tmp
export HOME=/data/local/tmp/kali/root

### Run termux-x11 ###

echo "DISPLAY=:1"
/data/data/com.termux/files/usr/bin/pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1 & > /dev/null

echo "PulseAudio started"
/data/data/com.termux/files/usr/bin/termux-x11 :0 &
X11_PID=$!
echo "Termux-x11 started"

### Exit Termux-x11 and Pulseaudio

echo "Press any key to terminate"
while true; do
read -rsn1 key  # Read a single character silently
if [[ -n "$key" ]]; then
kill $X11_PID
pkill pulseaudio
break  # Exit the loop if a key is pressed
fi
done

busybox chroot $UBUNTUPATH /bin/su - user -c "
export DISPLAY=:0 
PULSE_SERVER=tcp:127.0.0.1:4713 && 
dbus-launch --exit-with-session startxfce4"
