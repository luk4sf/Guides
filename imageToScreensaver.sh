#!/bin/bash

# Starting output index
index=5

# Loop through all JPG files in the current directory
for img in *.jpg; do
  # Skip if no jpg files found
  [[ -e "$img" ]] || continue

  # Set output file name
  output="screensaver${index}.png"

  # Run the convert command with the specified transformations
  convert "$img" \
    -colorspace Lab \
    -filter LanczosSharp \
    -distort Resize 758x1024 \
    -colorspace sRGB \
    -background black \
    -gravity center \
    -extent 758x1024! \
    -grayscale Rec709Luminance \
    -colorspace sRGB \
    -dither Riemersma \
    -remap eink_cmap.gif \
    -quality 75 \
    "png:$output"


  # Increment the index
  ((index++))
done