#!/bin/bash

# Target the specified directory, or fallback to the current directory
TARGET_DIR="${1:-.}"

# Verify if the target path is a valid directory
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: '$TARGET_DIR' is not a valid directory."
    exit 1
fi

echo "Sorting PNG files in '$TARGET_DIR' from largest to smallest:"
echo "--------------------------------------------------------"

# Find PNGs, get human-readable sizes, sort numerically descending, and display
# -maxdepth 1 limits the search to the specified folder only (no subfolders)
find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.png" -exec du -h {} + | sort -hr
