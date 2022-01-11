# From node01
for i in `seq 2 6`; do gluster peer probe ftgluster0$i; done
gluster volume create vol01 disperse-data 4 redundancy 2 transport tcp ftgluster01:/rhgs/sdb/sdb ftgluster02:/rhgs/sdb/sdb ftgluster03:/rhgs/sdb/sdb ftgluster04:/rhgs/sdb/sdb ftgluster05:/rhgs/sdb/sdb ftgluster06:/rhgs/sdb/sdb
gluster volume add-brick vol01 ftgluster01:/rhgs/sdc/sdc ftgluster02:/rhgs/sdc/sdc ftgluster03:/rhgs/sdc/sdc ftgluster04:/rhgs/sdc/sdc ftgluster05:/rhgs/sdc/sdc ftgluster06:/rhgs/sdc/sdc
