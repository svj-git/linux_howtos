# From mountpoint / In all found files replace old_string with new_string this example is DANGEROUS because ./ means in entire filesystem
find ./ -type f -exec sed -i 's/old_string/new_string/gI' {} \;

# Rename multiple files in distros like: RHEL,RHEL clones, Fedora
rename Old New OldName*
# Rename all .html to .txt for ALL files
rename -S .html .txt *.html
# Example of mass renamerename in Debian -n switch means no change will be written to files. This example renames html extension to php
rename -n 's/\.html$/\.php/' *.html

# Video conversion loop
#!/bin/bash
for INF in *.mp4
do
  ffmpeg -i "$INF" -c:v libsvtav1 -g 100 -preset 1 -crf 36 -pix_fmt yuv420p -c:a copy "${INF%.*}.mkv"
done
# ffmpeg cutting video
# cut using specified time
ffmpeg -i input.mp4 -ss 00:05:10 -to 00:15:30 -c:v copy -c:a copy output2.mp4
# cut using duration
ffmpeg -i input.mp4 -ss 00:05:20 -t 00:10:00 -c:v copy -c:a copy output1.mp4
# Extract audio ffmpeg without reencoding
ffmpeg -i inputfile.mkv -vn -acodec copy output-audio.aac

# Test if postfix user can read /etc/resolv.conf file
sudo -u postfix -H cat /etc/resolv.conf

# Parallel and sg_format all drives simultaneously very dangerous it will delete ALL YOUR DATA!
parallel sg_format --format -e ::: /dev/sg{2..126}

# Find and delete bad zip files
find . -iname '*.zip' -type f -readable ! -exec unzip -t {} \; -exec rm -i {} \;

# Using any dd command is extremely dangerous. I would recommend to write your command first and copy paste in bash prompt
# Clone contents of disk disk to another directly
dd if=/dev/sdX of=/dev/sdX bs=64m conv=noerror
# Clone disk image to actual disk
dd if=/home/homedir/test.img of=/dev/sdX bs=64M conv=noerror
# Create disk image from disks
dd if=/dev/sdX of=/home/homedir/test.img bs=64M conv=noerror

# Same as above but using cat
cat path/to/archlinux-version-x86_64.iso > /dev/sdX

# Create the btrfs file systems
mkfs.btrfs /dev/sdX1 --csum xxhash
# Mount the first drive
mount /dev/sde1 /mnt/raid
# Add the second drive - resulting in combined storage capacity spanned across both drives
btrfs device add /dev/sdX1 /mnt/raid -f
# Create RAID1 of data and metadata (important in case one drive fails)
# Depending on your drive size, this can take several hours to complete
btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt/raid

# Redirecting UUID to /etc/fstab
lsblk -n -o UUID /dev/nvme0n1p1 >> /etc/fstab
# Custom lsblk showing disk model, device name from /dev/* directory, size, mount point, file system type, UUID
lsblk -o MODEL,KNAME,SIZE,MOUNTPOINT,FSTYPE,UUID

# Change Newline character to space
tr '\n' ' ' < input_filename

# Change space character to newline
sed 's/ /\'$'\n''/g' filename

# Lowercase everything in file
tr '[:upper:]' '[:lower:]' < input.txt > output.txt

# Add :80 characters at the end of line
sed s/$/:80/ file.txt > another_file.txt

# Use gnupg to verify signature of iso file in this specific case AVLinux
dnf -y install gnupg
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 5DBC090C710C87B3
gpg --verify AVL_MXE-23.2-20240405_x64.iso.sig AVL_MXE-23.2-20240405_x64.iso

# Check hash sha256sum from echo
echo "fa1428fb09b422ec4a62363e831a5b84fbb8f7cf45ac9ddf054ee75f4f201e92 X9SRL8_B13.zip" | sha256sum --check

# Check hash sha256sum from file sha256 specific case AVLinux
sha256sum -c AVL_MXE-23.2-20240405_x64.iso.sha256 AVL_MXE-23.2-20240405_x64.iso

# If needed, the nmcli connection modify command can be used to change the DNS servers being used. This change will be persistent, meaning the change will remain in place even if the system is rebooted.
nmcli connection modify eth0 ipv4.dns "10.124.141.51,10.112.42.10"
nmcli device reapply eth0

# How to keep processes running after ending ssh session? Solution is to switch them to background
# nohup
nohup long-running-command &
# It was made specifically for this, it even logs stdout to nohup.log.
# Pause process
ctrl + z
# Put it in background
bg
# Actually disown it
disown -h

# Before using hard drives it is very good practice to the burn test them
# Get HDD recommended blocksize
blockdev --getbsz /dev/sdX
# Badblocks destructive hard drive test
badblocks -t random -w -s -b {blocksize} /dev/sdX

# Make wake on lan persistent across reboots: put this line in your cron
@reboot /usr/bin/ethtool -s interface wol g

# SELINUX relabeling
# If you mount disk image or chroot-ed image and change contents of files like /etc/shadow SELINUX relabel is necessary step for distros with selinux otherwise modified image will fail to boot
touch /.autorelabel

# Mount vm image read only. Requires package libguestfs
guestmount -a jdown.qcow2 -i --ro /tmp/tmp22

# Convert vm image file raw/img to qcow2
qemu-img convert -p -f raw -O qcow2 convertedimage.img  resulting.image.qcow2

# Prevent Writes to mount point when nothing is mounted. Very useful in case of mounted network file systems
# Unmount Directory:
umount /mnt/backup
# Set ‘immutable’ Flag:
chattr +i /mnt/backup
# Mount Directory again:
mount -t nfs 192.168.2.1:/mnt/nfs /mnt/backup

# RHEL like only. You must have intel_iommu=on in your grub or grub2, or other boot loader line. Requires package grubby.
grubby --update-kernel ALL --args intel_iommu=on
grubby --update-kernel ALL --args iommu=pt
dracut -f --kver $(uname -r)
# After the machine the changes to your /etc/default/grub you'll need to make the changes permanent by typing
grub2-mkconfig -o /boot/grub2/grub.cfg

#  Forces to rebuild all initramfs for all kernels
dracut -f --regenerate-all

# Enable VF aka Virtual Function for virtual mediated device passthrough
# SRIOV
# Create 64 Vfs on device enp7s0f0
echo 64 > /sys/class/net/enp7s0f0/device/sriov_numvfs
# Verify that there are 64 of them
lspci | grep 'Virtual Function' | wc -l

# Set keyboard to slovak keyboard variant qwerty only works if you have X11 installed
localectl set-x11-keymap sk variant qwerty

# Debian: If change of keyboard layout is desired and no X11 installed edit /etc/default/keyboard
# Alternative is to run dpkg-reconfigure
dpkg-reconfigure keyboard-configuration
#
setupcon
# Subsequently update initramfs
update-initramfs -u

# Test if user postfix can resolve example.com
sudo -u postfix -H dig example.com @192.168.1.1
# Test inf user postfix can read /etc/resolv.conf
sudo -u postfix -H cat /etc/resolv.conf

# Send test message via email useful for mail debugging
echo "$HOSTNAME" | mailx -s "$HOSTNAME" username@example.com

# Ping multiple hosts using fping utility
fping -c 3 192.168.1.50 192.168.1.55
# Ping entire subnet range
fping -q -a -g 192.168.1.0/24

# Stress test on all cpus using aggressive flag will print temperature result and lasts 24 hours Requires package stress-ng
stress-ng --cpu 0 --aggressive -t 24h --tz

# Use lgogdownloader to download your games from GOG. Download save serials download only English language, all optional downloads and for windows and linux
lgogdownloader --save-serials --language en --include all –download –platform w+l

# Search for all files and replace all occurences of Original_word with Replaced_word. Sed -i option means in file instead of standard output
find ./ -type f | xargs sed -i 's/Original_word/Replaced_word/g'

# Disable mouse acceleration
sudo dnf -y install xinput ; sudo apt-get install xinput
# Using xintput command figure out which number corresponds to your mouse
# Run command which will disable mouse acceleration
xinput --set-prop 9 'libinput Accel Speed' -1
# if it works add it to your ~/.bash_profile
echo "xinput --set-prop 9 'libinput Accel Speed -1'" >> ~/.bash_profile

# Test if gentoo.org domain is resolved by ipfire DNS server: 81.3.27.54
dig www.gentoo.org @81.3.27.54

# Create DVD/CD iso image out of zip file useful to passing read only data to VMs
genisoimage -J -R -o vmiso.iso zipcompressed.zip
# Create iso file from zipped archive using mkisofs
mkisofs

# Enlarge VM disk image files
# Show Vm disk image file systems
virt-filesystems -a /mnt/disk/vmdisk1.qcow2  -l
# Create empty file
truncate -s 13G vm_image.qcow2
# Resize VM image file, Expand partition sda2 of old_image.qcow2 into new new_image.qcow2 image
virt-resize --expand /dev/sda2 old_image.qcow2 new_image.qcow2

# Add new service file to firewalld
firewall-cmd --permanent --new-service=myservice
firewall-cmd --permanent --service=myservice --set-description=description
firewall-cmd --permanent --service=myservice --set-short=description
firewall-cmd --permanent --service=myservice --add-port=portid[-portid]/protocol

# To perform complete factory reset from a local:
ipmitool raw 0x30 0x40
# Complete factory reset from other computer
ipmitool –H [bmc_ip] –U [username] –P [password] raw 0x30 0x40
#
ipmitool bmc reset cold

# Set address to static address
ipmitool lan set 1 ipsrc static
# Set ip address to: 192.168.1.88
ipmitool lan set 1 ipaddr 192.168.1.88
# Set your netmask to: 255.255.255.0
ipmitool lan set 1 netmask 255.255.255.0
# Set default gateway server to: 192.168.44.4
ipmitool lan set 1 defgw ipaddr 192.168.44.4

# Debian how to change keyboard layout in Debian Linux without Xorg
dpkg-reconfigure console-data
dpkg-reconfigure keyboard-configuration

# Rsync trailing slash behavior as of rsync version 3.1.3 stolen from https://stackoverflow.com/questions/31278098/slashes-and-the-rsync-command
# 1. rsync -avPzu test    login@remote:/home/login/test   "test" directory is copied inside of existing "test" on remote (structure is then test/test/...)
# 2. rsync -avPzu test    login@remote:/home/login/test/  same as above
# 3. rsync -avPzu test/   login@remote:/home/login/test   content of "test" directory is synchronized with the remote "test" directory
# 4. rsync -avPzu test/   login@remote:/home/login/test/  same as above
# 5. rsync -avPzu test    login@remote:/home/login/       same as above
# 6. rsync -avPzu test    login@remote:/home/login        same as above

# Transfer files using rsync recursively, archive mode, verbose and do not update do not overwrite files that are newer on destination.
rsync -ravu --progress username@192.168.1.140:/home/username/folder/ /mnt/backup
# Transfer files using rsync recursively, archive mode, verbose and do not update do not overwrite files that are newer on destination. REMOVES SYNCHRONIZED FILES FROM SOURCE
rsync -ravu --progress --remove-source-files username@192.168.1.140:/home/username/folder/ /mnt/backup
# Copy only empty directories/folders
rsync -a --filter="-! */" /mnt/8tback/ /home/rando/aaaback/8tback/
# Recreate folder directory structure
rsync -av -f"+ */" -f"- *" "/path/to/the/source/rootDir" "/tmp/test"

# Virsh live migration
virsh migrate --live --verbose vmname qemu+ssh://username@192.168.1.142/system

# Check if directories in relative path directory named "folders" are empty
[ "$(find ./folders -type f)" ] && echo "Not Empty" || echo "Empty"

# delete files but not folders interactive meaning you have to confirm all deletions
find /path/to/directory -type f -exec rm -iv {} \;

# How to enable codeready distro builder on Oracle Linux 9
dnf config-manager --set-enabled ol$(rpm -E %rhel)_codeready_builder

# List all repositories in RHEL_clones,Fedora
dnf repolist all

# Enable EPEL on RHEL clones
dnf -y install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm
# Enable RPMfusion on RHEL clones
dnf -y install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm

# Alma Linux 8
dnf config-manager --set-enabled powertools
#Alma Linux 9+
dnf config-manager --set-enabled crb
# Install EPEL
dnf install -y epel-release

# WARNING you will lose all your data. Reset database to state right after installation.
systemctl stop mysql
rm -rf /var/lib/mysql/*
sudo -u mysql mysql_install_db
systemctl start mysql

# Direct partition passthrough partition to VM libvirt config.
# Often you want direct passthrough of VM host storage to get near native performance direct partition passthrough allows you to do that.
<disk type="block" device="disk">
  <driver name="qemu" type="raw" cache="none"/>
  <source dev="/dev/disk/by-id/scsi-SATA_Hitachi_HDS72202_JK1151YAJ6EENA-part1" index="2"/>
  <backingStore/>
  <target dev="vdd" bus="virtio"/>
  <alias name="virtio-disk3"/>
</disk>

# use ethtool to show connection speed
ethtool eth0 | grep Speed

# List which process has opened specific file
lsof ~/datasheet.pdf

# Replace spaces with newlines \n outputs to standard out
tr '\n' ' ' < example

# Tired of typing the password every time want to login into another machine via ssh? Ssh passwordless login to the rescue.
ssh-copy-id user@somedomain
# If you get ssh-copy-id no identities found error typically you need to create RSA keys
ssh-keygen -t rsa

# Download only specified part of video
yt-dlp https://youtube.com/watch?v=xxx --download-sections "*2:45:00-2:46:14" --force-keyframes-at-cuts
# Download only audio
yt-dlp -x https://youtube.com/watch?v=xxx

# When Linux OS boots up it uses efifb to show boot log on your monitor. However attachment of this driver also prevents GPU to be reserved by qemu and passed through to VM. So we need to unbind it with command below.
# For pure qemu just put this into launching script
echo "efi-framebuffer.0" > /sys/bus/platform/devices/efi-framebuffer.0/driver/unbind

# Automated efi framebuffer disable for libvirt
#!/usr/bin/env bash

# 1. Download and install the QEMU hook helper from here: https://github.com/PassthroughPOST/VFIO-Tools
# 2. Place this file in /etc/libvirt/hooks/qemu.d/NAME OF YOUR VM/prepare/begin/disable-fb.sh
# 3. Make disable-fb.sh executable.

#!/bin/bash
VM_NAME="$1"
echo "libvirt-qemu disable-fb: Disabling efi-framebuffer to prepare to pass GPU to VM $VM_NAME" > /dev/kmsg 2>&1
echo "efi-framebuffer.0" > /sys/bus/platform/devices/efi-framebuffer.0/driver/unbind

# Decrypting and extracting a file
gpg cfile.txt.gpg

# Encrypt file with AES-128 symmetric cipher
gpg -c file.txt

# Encrypt file with symmetric AES cypher
gpg --symmetric --cipher-algo AES256 file.txt

# Hd-idle utlity can be used to spin down hard drives to save power. Spinning down a lot of hard drives can save you significant amount of power.
https://github.com/adelolmo/hd-idle
# Default example from hd-idle gh page
# Below command disables spindowns and of all disks and then enables on specified disks
hd-idle -i 0 -a sda -i 300 -a sdb -i 1200

# zip file manipulations
# -d flag zip file deletes file named test.txt from archive zippedfile.zip
zip -d zippedfile.zip test.txt
# -u flag zip file updates existing or adds new file named vfio.ko from archive zippedfile.zip
zip -u zippedfile.zip vfio.ko
# -m flag move specified files into archive zippedfile.zip
zip -m zippedfile.zip *.dlg
# -r flag compress directory into single archive
zip -r zipped.zip directory/
# -x flag exclude file from being extracted from zip archive
zip -r myarchive.zip . -x  a.txt

# Create multiple directories and intermediary directories if they do not exists
mkdir -p /tftpboot/{bios,efi64,netboot,pxelinux.cfg}

# Debian /etc/network/interfaces ip address assigned by dhcp server
allow-hotplug enp1s0
iface enp1s0 inet dhcp

# Debian /etc/network/interfaces static network interface configuration
auto enp2s0 # enabled at boot time
allow-hotplug enp2s0 # allows for hot plugging
iface enp2s0 inet static # static configuration
        address 192.168.47.3/24 # IPv4 address and netmask
        gateway 192.168.1.1 # gateway is typically ip address of router or firewall for access to internet or gateway if you have segmented network with routers
        mtu 9000

# Libvirt update default (virbr0) network with static ip address 192.168.122.107 host master which has MAC address 52:54:00:00:00:00
virsh net-update default add ip-dhcp-host "<host mac='52:54:00:00:00:00' name='master' ip='192.168.122.107' />" --live --config

# same as above but delete line
virsh net-update default delete ip-dhcp-host "<host mac='52:54:00:00:00:00' name='master' ip='192.168.122.107' />" --live --config

# Write br_netfilter to a file /etc/modules-load.d/br_netfilter.conf. Useful when used in scripts.
echo "br_netfilter" >> /etc/modules-load.d/br_netfilter.conf

# Cronjob which sends each hour errors of emergency to alert severity recorded by journald to specified email
@hourly journalctl --since="1 hour ago" -p "emerg".."alert" -q | mailx -E -s "Journald Errors" user@example.com

# Example of DNSMASQ tftpboot pxelinux.cfg/default file
MENU TITLE PXE Boot Menu
DEFAULT vesamenu.c32
# will wait ten seconds before attempting to boot automatically. In this config it means in 10 seconds dnsmasq will attempt to do local hdd boot.
TIMEOUT 100
# default
LABEL LOCAL
MENU LABEL Boot from local drive
LOCALBOOT 0xffff
# Entry for each OS needs Kernel and Initrd entry and most Linux distros will also require extracted contents of ISO image accessible via LAN which can be NFS,FTP,HTTP
# If installation via internet is preferred you can point to public HTTP/FTP repository

# Debian does not need any append options for network install
MENU BEGIN Debian13
MENU TITLE Debian13
LABEL install
MENU LABEL Install Debian13
  KERNEL ::netboot/debian13/linux
  INITRD ::netboot/debian13/initrd.gz
MENU END
# Alma Linux install from http repository for Ivy Bridge  Piledriver,Steamroller
MENU BEGIN AlmaLinux 10 v2 Ivy Bridge  Piledriver,Steamroller
MENU TITLE AlmaLinux 10 v2 Ivy Bridge  Piledriver,Steamroller
LABEL install alma linux 10 v2
MENU LABEL Install alma linux 10v2
  KERNEL ::netboot/alma10v2/vmlinuz
  INITRD ::netboot/alma10v2/initrd.img
  APPEND ip=dhcp rd.shell inst.stage2=<https://mirrors.almalinux.org>/almalinux/10.0/BaseOS/x86_64_v2/os/
MENU END
# Alma Linux install from http repository RHEL 10 has deprecatadted older x86_64V2 CPU architectures So if your CPUs Haswell+ and Excavator+ use this.
MENU BEGIN AlmaLinux 10 x86-64v3 Haswell+ Excavator
MENU TITLE AlmaLinux 10 x86-64v3 Haswell+ Excavator
LABEL install alma linux 10
MENU LABEL Install alma linux 10
  KERNEL ::netboot/alma10/vmlinuz
  INITRD ::netboot/alma10/initrd.img
  APPEND ip=dhcp rd.shell inst.stage2=<https://mirrors.almalinux.org>/almalinux/10.0/BaseOS/x86_64/os/
MENU END
# Oracle LInux 8 install from nfs share located on server 192.168.1.1 with setting nfs version to 4.2
MENU BEGIN Oracle Linux 8
MENU TITLE Oracle Linux 8
LABEL install oracle linux 8 fro NFS share
MENU LABEL Install oracle linux 8
  KERNEL ::netboot/oracle8/vmlinuz
  INITRD ::netboot/oracle8/initrd.img
  APPEND ip=dhcp rd.shell inst.repo=nfs:nfsvers=4.2:192.168.1.1:/mnt/nfsmount/oracle8exctractediso
MENU END
# System Rescue 12.02 Live distro boot from 192.168.1.1 NFS share, ro=read only mount, ip=dhcp automatic ip setup
MENU BEGIN System Rescue 12.02-amd64
MENU TITLE System Rescue 12.02-amd64
LABEL sysresccd boot into live system
  LINUX ::netboot/systemresc-12.02/sysresccd/boot/x86_64/vmlinuz
  INITRD ::netboot/systemresc-12.02/sysresccd/boot/intel_ucode.img,::netboot/systemresc-12.02/sysresccd/boot/amd_ucode.img,::netboot/systemresc-12.02/sysresccd/boot/x86_64/sysresccd.img
  APPEND ro archisobasedir=sysresccd ip=dhcp archiso_nfs_srv=192.168.1.1:/mnt/nfsmount/system_rescue_exctractediso
  SYSAPPEND 3
MENU END
# Fedora 42 distro boot from NFS share 192.168.1.1 with setting nfs version to 4.2. inst.noipv6=disables ipv6, ro=read only mount, rd.shell=debug option
MENU BEGIN Fedora 42
MENU TITLE Fedora 42
LABEL Fedora 42
  KERNEL ::netboot/fedora42/vmlinuz
  INITRD ::netboot/fedora42/initrd.img
  APPEND inst.noipv6 ro rd.shell inst.repo=nfs:nfsvers=4.2:192.168.1.1:/mnt/nfsmount/fedora_42_extracted_iso_directory
TEXT HELP
   Boot to Fedora 42
   User: liveuser
ENDTEXT
MENU END
# Suse tumbleweed install from http repository
MENU BEGIN Suse tumbleweed
MENU TITLE Suse tumbleweed
LABEL Suse tumbleweed
  KERNEL ::netboot/suse-tumbleweed/linux
  INITRD ::netboot/suse-tumbleweed/initrd
  APPEND install=https://download.opensuse.org/tumbleweed/repo/oss/
TEXT HELP
   Install Suse tumbleweed http network install
ENDTEXT
MENU END

MENU END

# Suppose your routing table has been hijacked by br0 bridge which you have disabled. How do you restore default route?

# First line of ip route command may looks like so↓↓↓↓↓
# default via 192.168.1.2 dev br0
# Command to remove default routing via br0:
ip route delete default via 192.168.1.2 dev br0
# In case your bridge br0 is still active delete it with following command
ip link del br0 type bridge


# NETWORK MANAGER key file example
[connection]
id=enp8s0
uuid=66ee140a-9870-4ef2-b43f-7aa3b85b64ed
type=ethernet
interface-name=enp8s0
autoconnect=true
mac-address=52:54:00:00:00:00
[ethernet]
mtu=9000

[ipv4]
address1=192.168.2.241/24
#dns=192.168.1.1;
may-fail=false
method=manual

[ipv6]
method=disabled

# Network manager modify interface eno1 with ip address with netmask /24 192.168.1.66/24 and gateway 192.168.1.1
nmcli connection modify eno1 ipv4.addresses 192.168.1.66/24 ipv4.gateway 192.168.1.1

# Systemctl list only failed services
systemctl --failed

# Set your boot target to graphical.target. Useful lets say if you are upgrading from minimal install to GUI workstation as default multiuser.target will boot you into CLI only inteface.
systemctl set-default graphical.target
# Shows systemd default boot target.
systemctl get-default

# How to use curl to manipulate webdav share.
# Send a file :
curl -T file.ext https://192.168.1.240/webdavdata/ -u user:password

# Retrieve a file:
curl https://192.168.1.240/webdavdata/file.ext -u user:password -o file.ext

# Rename or move a file :
curl -X MOVE --header "destination:https://192.168.1.240/webdavdata/madeupfoldername/file.ext" "https://192.168.1.240/webdavdata/oldfolder/file.ext" -u user:password

# Create a folder :
curl -X MKCOL https://192.168.1.240/datawebdav  -u user:password

# Delete a file/folder :
curl -X DELETE https://192.168.1.240/datawebdav/file.ext -u user:password.

# Command to get preseed file from Debian installation. It is Debian equivalent to anaconda-ks.cfg file for automated installs
apt install debconf-utils
debconf-get-selections [--installer] >> preseed.cfg

# Journalctl show only messages related to specified service
journalctl -u rsyslog.service

# Play video in 360p resolution.
mpv --ytdl-format="best[height=360]/bestvideo[height=360]+bestaudio"

# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash" change to GRUB_CMDLINE_LINUX_DEFAULT="quiet splash ipv6.disable=1"s
grubby --update-kernel ALL --args ipv6.disable=1

# This incomplete snipped allows you to point to http server install directly from debian mirror using http
virt-install https://ftp.debian.org/debian/dists/Debian13.1/

# Set timezone on Debian system
dpkg-reconfigure tzdata

# Use dumpxml on debian13 to search its configuration if its qcow2; Necessary for our snapshots to work.
virsh dumpxml finnix | grep -i qemu
# Create snapshot of VM with name debian13 snapshot name default
virsh snapshot-create-as --domain debian13 --name default
# List existing snapshots of VM with name finnix
virsh snapshot-list --domain finnix
# Create snapshot of VM with name finnix snapshot name default --description is explanatory. Which is currently running.
virsh snapshot-create-as --domain finnix --name "default" --description "Write here snapshot description" --live

# Create snapshot of offline finnix VM
# Shutdown finnix VM
virsh shutdown finnix
# Create snapshot of VM with name finnix snapshot name default --description is self explanatory.
virsh snapshot-create-as --domain finnix --name "default" --description "Write here snapshot description"
# Start the VM
virsh start finnix

# Display VM with name finnix info about snapshot default
virsh snapshot-info --domain finnix --snapshotname default
# Delete snapshot of VM finnix default snapshot.
virsh snapshot-delete --domain finnix --snapshotname default

# Create snapshot of VM which has snapshot name default --description is explanatory. Capture disk state only of running VM which has name finnix
virsh snapshot-create-as --name "default" --description "Write your comment here" --disk-only --live --domain finnix

# List of Linux kernel configuration option. Useful perhaps if you wish to know which features has your kernel enabled.
# =y means feature compiled in kernel in
# =m means feature can be loaded as kernel module.
# Is no set means your kernel was not compiled with said feature and you will have to recompile your kernel if you want your feature enabled.
cat /boot/config-$(uname -r)

# Sort and only write unique lines from file1 to file2
sort -o file1 -u file2

# ~backupuser/.ssh/authorized_keys on the CLIENT machine This line forces very very restrictive rsync command with root priviledges executed from pull machine.
command="sudo /usr/bin/rsync --server --sender -vlogDtprze.iLsf --delete . /",no-port-forwarding,no-X11-forwarding,no-pty ssh-rsa AAAAB3NzaC1yc2E...key_from_backup_server

# Restrict user to only execut this command ↓↓↓↓
# On the CLIENT machine
backupuser ALL=(ALL) NOPASSWD: /usr/bin/rsync

# Pipewire only so only modern linux with. Set
pw-metadata -n settings 0 clock force-quantum 256


# virtual netwoking red hat
https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking
# generic linux cheatsheet
http://gnulinux.guru/networking_cheatsheet.html
# btrfs
https://blog.programster.org/btrfs-cheatsheet
# zfs
https://blog.programster.org/zfs-create-disk-pools
# how to bridge
https://linuxconfig.org/how-to-use-bridged-networking-with-libvirt-and-kvm


https://www.privoxy.org/user-manual/configuration.html
