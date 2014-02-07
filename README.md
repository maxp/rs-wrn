
# Angara.Net - Remote Sensor


## OpenWRT on TL-WR703N

    curl -o openwrt-1209.bin \
      http://downloads.openwrt.org/snapshots/trunk/ar71xx/openwrt-ar71xx-generic-tl-wr703n-v1-squashfs-factory.bin

http://192.168.1.1/

left menu last / submenu third "/userRpm/SoftwareUpgradeRpm.htm"

upgrade

login - qwe123 tpl.sobol14

Network / Interfaces: 

iface: x.x.x.99 gw x.x.x.1
dns: 8.8.8.8
dhcp: server disable

Network / WiFi:

  Channel: auto
  Mode: client
  ESSID: BSK_DSI
  interface: wan

Network / Interfaces - WAN:
  
  Protocol: DHCP / Client  

System / System:
  
  Hostname: xxxx

System / Administration:

  SSH-Access: lan

System / Software:

update package list

install coreutils-sha1sum
install kmod-usb-serial-ftdi
install kmod-usb-serial-pl2303


