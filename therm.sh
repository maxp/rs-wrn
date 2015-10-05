#!/bin/sh

# /etc/crontabs/root:
# */5 *   *  *  *  /www/therm.sh
# 3   */2 *  *  *  /www/watch.sh

# chmod +x /www/*.sh
# /etc/init.d/cron enable

# rc.local:
#  sleep 10; /www/therm.sh

# /www/watch.sh:

#!/bin/sh
#
# if ! ping -q -c 1 -W 9  "8.8.8.8"  > /dev/null; 
# then
#
#   /sbin/reboot
#
#     echo 0 > /sys/devices/virtual/gpio/gpio8/value
#     sleep 2
#     echo 1 > /sys/devices/virtual/gpio/gpio8/value
#     sleep 10
#     usb_modeswitch -v 0685 -p 2000
#     sleep 50
# fi

# install kmod-ftdi, kmod-pl2303, coreutils-sha1sum


psw="secret"
url='http://example.com/dat?'

port='/dev/ttyUSB0'
hwid=`ifconfig | grep HWaddr | head -1 | awk '{print $5}'`
wget='wget -q -O - '


cycle_file='/tmp/cycle'                                   
cycle_data='/tmp/cycle.dat'
                                                          
touch $cycle_file
cycle=`cat $cycle_file`
if [ "$cycle" == "" ] ;
then
    cycle=1
else
    cycle=`expr $cycle + 1`
fi                                 
echo $cycle > $cycle_file
echo "cycle:" $cycle

#

read -t 5 val <> $port
echo $cycle > $cycle_data
echo $val  >> $cycle_data

#read -t 5 val2 <> $port
#read -t 5 val3 <> $port

#val=""
#
#if [ "$val1" == "$val2" ] ;
#then
#        val=$val1
#fi
#
#if [ "$val2" == "$val3" ] ;
#then
#        val=$val2
#fi
#
#if [ "$val" == "" ] ;
#then
#        echo "term read error"
#        exit 1
#fi

#if [[ ${#val} != 8 ]] ;
#then
#        echo "term value format error"
#        exit 2
#fi
#
#h0=`expr substr $val 5 2`
#h1=`expr substr $val 7 2`
#
#val=$((0x${h1}${h0}))
#
#if [ $val -gt 32767 ] ;
#then
#  val=$(($val - 65536))
#fi
#
#val=$(( $val / 2 ))        # / 16

#if [ $val -gt -60 -a $val -lt 60 ] ;
#then
#    echo "t:" $val

qs="hwid=${hwid}&cycle=${cycle}&t=${val}"
hk=`echo -n "${qs}${psw}" | sha1sum | cut -f 1 -d " "`
    
echo "q:" $qs $hk

qs="${qs}&_hkey=${hk}"
rc=`${wget} ${url}${qs}`

#    # echo 'rc:' $rc
#else
#    echo "therm value out of range:" ${val}
#    exit 3
#fi

exit 0

#.


# ----------------------------------------------------------------------------- #

# ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.1.1

# .ssh/config:
#
# Host 192.168.0.*
#   StrictHostKeyChecking no
#   UserKnownHostsFile /dev/null

telnet 192.168.1.1
passwd qwe123

ifconfig eth0:1 ...
route add default gw ...
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

opkg update
opkg install kmod-usb-serial-ftdi
opkg install kmod-usb-serial-pl2303

# check /dev/ttyUSB0

opkg install comgt
opkg install kmod-usb-serial-option
opkg install kmod-usb-serial-wwan
opkg install usb-modeswitch-data
opkg install usbutils

# opkg install usbreset?



= Config

/etc/config/dhcp:

config dhcp lan
        option interface        lan
        option ignore 1

config dhcp wan
        option interface        wan
        option ignore   1


/etc/config/network:

config interface 'lan'
        option ifname 'eth0'
        option proto 'static'
        option ipaddr '192.168.1.1'
        option netmask '255.255.255.0'
        option ip6assign '60'
        # option gateway 192.168.1.???
        # option dns 8.8.8.8

# config interface 'wan'
#        option ifname 'wlan0'
#        option proto 'dhcp'
#        option hostname 'ws-mark'

config interface 'wan'       
        option ifname 'ppp0'        
        option device '/dev/ttyUSB1'
        option proto '3g'           
        option service 'umts'       
        option apn 'internet'
        option pincode '6564'
                            

/etc/config/system:

config system
        option hostname rs_host
        option timezone UTC


# /etc/config/wireless:

# config wifi-device wifi
#         option type     mac80211
#         option channel  auto
#         option hwmode   11ng
#         option path     'platform/ar933x_wmac'
#         option htmode   HT20
#         list ht_capab   SHORT-GI-20
#         list ht_capab   SHORT-GI-40
#         list ht_capab   RX-STBC1
#         list ht_capab   DSSS_CCK-40
#         option disabled 0

# config wifi-iface
#         option ifname   wlan0
#         option device   wifi
#         option network  wan
#         option mode     sta
#         option encryption psk2
#         option ssid     "mynetwork"
#         option key      "12345"

if ! ping -q -c 1 -W 10 -I 3g-wan 8.8.8.8 > /dev/null; then
        (ifup wan; sleep 5; /etc/init.d/multiwan restart) &
fi


# stop the system attempting to restart the failed modem
ifdown wan
# turn off USB power
echo 0 > /sys/devices/virtual/gpio/gpio6/value
# let things settle
sleep 2
# turn on USB power
echo 1 > /sys/devices/virtual/gpio/gpio6/value
# restart the interface
ifup wan

#####################################################################################
