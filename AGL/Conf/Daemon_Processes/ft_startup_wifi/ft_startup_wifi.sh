#!/bin/sh

#logger "ft_startup_wifi: Starting Wifi..."
echo "working" > /tmp/ft_start_wifi.log
rfkill unblock wifi
networkctl up wlan0
#logger "ft_startup_wifi: Wifi enabled :3"
exit 0
