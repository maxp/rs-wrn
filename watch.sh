#!/bin/sh

# /www/watch.sh:

if ! ping -q -c 1 -W 9  "8.8.8.8"  > /dev/null; 
then
  /sbin/reboot
#
#     echo 0 > /sys/devices/virtual/gpio/gpio8/value
#     sleep 2
#     echo 1 > /sys/devices/virtual/gpio/gpio8/value
#     sleep 10
#     usb_modeswitch -v 0685 -p 2000
#     sleep 50
fi

#.

