# How to Configure University of Freiburg eduroam on Ubuntu 22.04.3 LTS (Jammy Jellyfish)

1. **Open Wi-Fi Settings**
   - Go to the network tab and open the Wi-Fi settings.

2. **Select eduroam**
   - Choose `eduroam` from the list of available networks.

3. **Configure Authentication Settings**
   - Set **Authentication** to `Protected EAP (PEAP)`.
   - Leave the **Anonymous Identity** and **Domain** fields empty.

4. **Configure Security Options**
   - **CA Certificate**: Set to `(None)`.
   - **PEAP Version**: Leave as `Automatic`.
   - **Inner Authentication**: Set to `MSCHAPv2`.
   - Check the box that says `No CA certificate is required`.

5. **Enter Your Credentials**
   - **Username**: Enter your username followed by `@uni-freiburg.de` (e.g., `mm123@uni-freiburg.de`).
   - **Password**: Enter your RAS password. If you don’t remember your password, you can reset it at [myaccount.uni-freiburg.de](https://myaccount.uni-freiburg.de/).

6. **Connect**
   - Click `Connect` to join the eduroam network.

