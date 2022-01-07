# Reboot before starting
members="ftgfs01 ftgfs02 ftgfs03"
- name: Auth Hosts
pcs host auth $members -u hacluster -p fosstech
- name: Setup Cluster
pcs cluster setup ftcluster --start $members
pcs cluster setup ftcluster --start node01 addr=ipaddr addr=ipaddr node02 addr=ipaddr addr=ipaddr node03 addr=ipaddr addr=ipaddr
- name: Enable Cluster Service
pcs cluster enable --all
- name: Setup vmware_fence_rest
pcs stonith create vmfence fence_vmware_rest pcmk_host_map="ftgfs01:ftgfs01,ftgfs02:ftgfs02,ftgfs03:ftgfs03" ipaddr=192.168.8.10 ssl=1 login=administrator@fosstech.biz password=F055tech ssl_insecure=1
- name: Test Fencing
fence_vmware_rest -o reboot -a 192.168.8.10 -l administrator@fosstech.biz -p F055tech -z --ssl-insecure -n ftgfs02
- name: Set quorum policy to freeze - GFS should not stop(default) even without quorum  
pcs property set no-quorum-policy=freeze
- name: Create locking resource
pcs resource create dlm --group locking ocf:pacemaker:controld op monitor interval=30s on-fail=fence
pcs resource create lvmlockd --group locking ocf:heartbeat:lvmlockd op monitor interval=30s on-fail=fence
pcs resource clone locking interleave=true
- name: Create gfs vg, journal number is the number of nodes -j3 for 3 nodes
vgcreate --shared sharedvg /dev/sdb
lvcreate --activate sy -L3G -n sharedlv1 sharedvg
lvcreate --activate sy -L2G -n sharedlv2 sharedvg
mkfs.gfs2 -j3 -p lock_dlm -t ftcluster:svglv1 /dev/sharedvg/sharedlv1
mkfs.gfs2 -j3 -p lock_dlm -t ftcluster:svglv2 /dev/sharedvg/sharedlv2
# On All Nodes
vgchange --lock-start sharedvg
- name: Create GFS
pcs resource create sharedlv1 --group sharedvg ocf:heartbeat:LVM-activate lvname=sharedlv1 vgname=sharedvg activation_mode=shared vg_access_mode=lvmlockd
pcs resource create sharedlv2 --group sharedvg ocf:heartbeat:LVM-activate lvname=sharedlv2 vgname=sharedvg activation_mode=shared vg_access_mode=lvmlockd
pcs resource create sharedfs1 --group sharedvg ocf:heartbeat:Filesystem device="/dev/sharedvg/sharedlv1" directory="/mnt/svglv1" fstype="gfs2" options=noatime op monitor interval=10s on-fail=fence
pcs resource create sharedfs2 --group sharedvg ocf:heartbeat:Filesystem device="/dev/sharedvg/sharedlv2" directory="/mnt/svglv2" fstype="gfs2" options=noatime op monitor interval=10s on-fail=fence
pcs resource clone sharedvg interleave=true
- name: Ensure locking done before vg
pcs constraint order start locking-clone then sharedvg-clone
- name: Cleanup Stonith Message
stonith_admin --cleanup --history ftgfs02    
