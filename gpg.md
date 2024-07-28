# Change expiry date

```bash
gpg --edit-key randyranders0n@protonmail.com
list
key 0
expire
save
```
# Change passphrase

```bash
gpg --passwd randyranders0n@protonmail.com
```
# Revoke key certificate

Remove the colon infront of the 5 dashes with a text editor and then run
```bash
gpg --import /home/lukas/.gnupg/openpgp-revocs.d/revrevoke-file.rev
```
# Deleting keys
```bash
gpg --list-keys 
gpg --list-secret-keys
gpg --delete-key keyid
gpg --delete-secret-key keyid
```