Certainly! I'll format the markdown file with proper code blocks and organize the content for better readability.

```markdown
# Linux Workarounds

## Get Current Path

To get the current path:

```sh
pwd
```

## Convert HEIC to JPG

To convert `.HEIC` files to `.JPG` files, use the `heif-convert` tool:

1. Install the package:

    ```sh
    sudo apt install libheif-examples
    ```

2. Convert all `.HEIC` files in the current directory to `.JPG` while keeping the original names:

    ```sh
    for i in *.HEIC; do heif-convert "$i" "${i%.HEIC}.jpg"; done
    ```

## Delete All Files with Certain Name or Extension

To delete all files with a certain name or extension:

```sh
find . -name '*.json' -exec rm {} \;
```

## Move All Files with a Certain Name to a Folder

To move all `.mp4` files to a specific folder:

```sh
mv *.mp4 /home/lukas/Documents/Pictures/Handy/Galaxy/Google/Fotos/Photos/from/2023/Videos
```

## Get Single Images from Videos

To extract single images from videos using `ffmpeg`:

```sh
ffmpeg -i inputfile.avi -r 1 -f image2 image-%03d.jpeg
```

### Explanation:
- **`-r 1`**: Extracts 1 image per second of the video. Replace this number to adjust the number of images per second.
- **`-f image2`**: Forces the output format to images. This can often be omitted as `ffmpeg` tries to select the format based on the file extension.
- **`image-%03d.jpeg`**: Specifies the output file name pattern. `%03d` means the images will be numbered with three digits, padded with zeroes (e.g., `image-001.jpeg`).

## Use `dd` to Find Disk Hogs

To find disk hogs, including hidden files, use the following command:

```sh
du -sch .[!.]* * | sort -h
```

### Explanation:
- **`du -sch`**: Displays disk usage for each file and directory in human-readable format.
- **`.[!.]*`**: Matches hidden files and directories in the current directory, excluding `.` (current directory) and `..` (parent directory).
- **`*`**: Matches all non-hidden files and directories in the current directory.
- **`sort -h`**: Sorts the output in human-readable format (e.g., `1K`, `234M`, `2G`).

This command helps you identify large files and directories, including hidden ones like `/home/myAccount/.local/share/Trash`.
```

In this markdown file:

- I used triple backticks (```) to denote code blocks for commands and explanations.
- I organized the content into sections with headers for clarity.
- I replaced the asterisks used for code with proper backticks and improved the readability of the commands and their explanations.