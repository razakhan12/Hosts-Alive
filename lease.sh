#!/bin/tcsh 
## listleases.sh
## Displays a list of active DHCP leases
## NOTE: requires fping port to use

## Get pool(s) from /usr/local/etc/dhcpd.conf 
foreach POOL (`grep range /usr/local/etc/dhcpd.conf | awk '{print $2"_"$3}' | sed 's/;//g'`)
  set POOLSET = `echo $POOL | sed 's/_/ /g'`
  echo "DHCP Pool: $POOLSET"
  
  ## use fping to find active IPs in the dhcp pool
  foreach ENTRY (`fping -a -g $POOLSET`)
        set ENTRYARP = `arp $ENTRY | awk '{print $4}'`
	set ENTRYUID = `grep -C7 "lease $ENTRY" /var/db/dhcpd/dhcpd.leases | grep -C3 "$ENTRYARP" | grep hostname | tail -n 1`
	echo "$ENTRY | $ENTRYARP | $ENTRYUID"
  end
end
