# Wireless Basics in Kali Linux

*ip link* to view the wireless devices and confirm the card has been detected

*iw dev ap stop/start* start or stop an access point - verify by running *ip link* and look for *UP*

*ip link set <device> up/down* e.g. *ip link set wlan0 up* - bring wireless card up

*airmon-ng* to verify it detects the card

*airmon-ng check* to check for proccesses that could cause trouble

*airmon-ng check kill* to kill those processes

*airmon-ng start/stop <device>* to put device in monitor mode - check with *airmon-ng*

*service NetworkManager start* to restart the network manager (got killed by airmon-ng)

*service wpa_supplicant start* to restart the wpa supplicant (got killed by aimon-ng)

# Find out hidden SSID

1. Wait for legitimate ProbeRequest and read out SSID or

2. Find out MAC-Address and launch a deauthentication attack to force the clients to reconnect and send a Probe Package. *sudo aireplay-ng -0 5 -a 3C:84:6A:DF:AB:7C --ignore-negative wlan0mon*.
*-0* is the deathtentication attack, 5 is the number of deauthentication packets to send and -a specifies the MAC address.

3. Put this filter in Wireshark to see all the non-Beacon traffic going to and from the access point:
*(wlan.bssid == <MAC>) && !(wlan.fc.type_subtype == 0x08)*

