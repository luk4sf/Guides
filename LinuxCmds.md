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

# Get single images from Videos
*ffmpeg -i inputfile.avi -r 1 -f image2 image-%3d.jpeg*

You can read the documentation here
    -r 1 extract 1 image per second of video. Replace that number for the number of images you 		want to get per second.
    -f image2 force image output format, you may probable be able to omit this since the program tries to choose the output images format from the file extension.
    image-%3d.jpeg name of the t from the foutput images, the %3d indicates that the output generated images will have a sequence number there of 3 decimals, if you want the number padded with zeroes you just need to use %03d.

