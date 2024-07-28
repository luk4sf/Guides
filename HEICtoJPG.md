# LINUX WORKAROUNDS

# Get current path
*pwd*

# Convert HEIC to JPG
To convert .HEIC files to .JPG files use the library heif-convert.
*sudo apt install libheif-examples* to install the package
*for i in *.HEIC; do heif-convert "$i" "${i%.HEIC}.jpg"; done* to convert all .HEIC files in the current folder to .JPG keeping the name.

# Delete all files with certain name or extension
*find  . -name '*json' -exec rm {} \;*

# Move all files with a certain name to a folder
*mv *.mp4 /home/lukas/Documents/Pictures\ Handy\ Galaxy/Google\ Fotos/Photos\ from\ 2023/Videos*


