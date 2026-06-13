#!/bin/bash

# Target directory (defaults to current directory if no argument is provided)
TARGET_DIR="${1:-.}"

# Ensure the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

echo "Scanning for duplicate PNG files in: $TARGET_DIR"
echo "------------------------------------------------"

# Find all PNG files, calculate MD5, and group duplicates
# Handles spaces and special characters in filenames safely
find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.png" -print0 | while IFS= read -r -d '' file; do
    # Generate MD5 hash for the file
    # Note: 'md5sum' is standard on Linux. Use 'md5 -q' on macOS.
    if command -v md5sum >/dev/null 2>&1; then
        hash=$(md5sum "$file" | awk '{print $1}')
    else
        hash=$(md5 -q "$file")
    fi
    echo "$hash $file"
done | sort | awk '
{
    hash = $1
    # Reconstruct filename if it contains spaces
    $1 = ""
    sub(/^ /, "", $0)
    file = $0

    if (seen[hash]) {
        print "Deleting duplicate: " file
        system("rm -f \"" file "\"")
    } else {
        seen[hash] = file
        print "Keeping original:   " file
    }
}'

echo "------------------------------------------------"
echo "Duplicate cleanup complete."
