#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# Use text mode install
text
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts=''
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=ens192 --ipv6=auto --activate
network  --hostname=ftgfs02.fosstech.biz

# Use network installation
url --url="http://192.168.8.13/RHEL-8.4/"
# Root password
rootpw --iscrypted $6$oBs31/9KvMWuEKvh$6FgLZSPxbh1auwwSvaT9ak99ziTnD4iRsM9dbUuKw6aBMvqi0VEQjdXdM/t6/d7kklR9tNfXyE7MhhZp7y9E00
# System services
services --enabled="chronyd"
# Do not configure the X Window System
skipx
# System timezone
timezone Asia/Singapore --isUtc
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
autopart --type=lvm
# Partition clearing information
clearpart --all --initlabel --drives=sda

%packages
@core
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
IPADDR=192.168.18.105
NETMASK=255.255.255.0
GATEWAY=192.168.18.254
DNS1=192.168.18.11
DNS2=8.8.8.8
TYPE=Ethernet
EOF

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
