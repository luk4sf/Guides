# How to configure University of Freiburg eduroam on 22.04.3 LTS (Jammy Jellyfish)

1. Go to the network tab and open the Wi-Fi settings.  

2. Select eduroam and select *Protected EAP (PEAP)* in the *Authentication* dropdown.  

3. Leave the *Anoymous identity* and *Domain* empty.  

4. *Ca certificate* stays at *(None)*, *(PEAP version)* stays at *Automatic* and *Inner authentication* stays at *MSCHAPv2*. Also check the box which says *No CA certificate is required*.  
  
5. Now just put in your username followed by *@uni-freiburg.de* e.g. *lf312@uni-freiburg.de* in the *Username* field and your RAS-Password in the *Password* field, if you don't remember your password you can change it at *https://myaccount.uni-freiburg.de/ *.

6. Now just hit connect!
