#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
text
firstboot --enable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=ens192 --ipv6=auto --activate
network  --hostname=ftgluster04.fosstech.biz

# Root password
url --url="http://192.168.8.13/RHGS-3.2/"
rootpw --iscrypted $6$MYBmFifPCMQ1x7Hz$ud1xR/GMwtyPrBzFDH1SnGYGxH20mX5AoifDMVeoBPoDarC24CGoJvFw.cJ/QXhO5PC.j.umzg4JAO9kVHqSO.
# System services
services --enabled="chronyd"
# System timezone
timezone Asia/Singapore --isUtc
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
autopart --type=lvm
# Partition clearing information
clearpart --none --initlabel
reboot

%packages
@^Default_Gluster_Storage_Server
@RH-Gluster-Core
@RH-Gluster-Swift
@RH-Gluster-Tools
@base
@core
@scalable-file-systems
chrony
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%post --log=/root/ks.log
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-ens192
NAME="ens192"
DEVICE="ens192"
ONBOOT=yes
NETBOOT=yes
BOOTPROTO=static
IPADDR=192.168.18.154
NETMASK=255.255.255.0
GATEWAY=192.168.18.254
DNS1=192.168.18.11
DNS2=8.8.8.8
DOMAIN=fosstech.biz
TYPE=Ethernet
EOF

%end


%anaconda
pwpolicy root --minlen=6 --minquality=50 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=50 --notstrict --nochanges --notempty
pwpolicy luks --minlen=6 --minquality=50 --notstrict --nochanges --notempty
%end
