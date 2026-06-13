#!/bin/bash

# Check if an argument was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <relative_folder_path>"
    exit 1
fi

# Target path relative to the current working directory
TARGET_DIR="$1"

# Verify if the target path is a valid directory
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: '$TARGET_DIR' is not a valid directory or does not exist."
    exit 1
fi

# Calculate folder size in Gigabytes (GB)
# du -bk reads sizes in bytes; awk converts and formats it to GB
SIZE_GB=$(du -sb "$TARGET_DIR" 2>/dev/null | awk '{printf "%.2f", $1 / 1024 / 1024 / 1024}')

# Display the output
echo "The size of '$(basename "$TARGET_DIR")' is ${SIZE_GB} GB."