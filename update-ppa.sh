#!/bin/bash

# Script to update PPA files after adding a new .deb package

# Check if dpkg-scanpackages and apt-ftparchive are installed
if ! command -v dpkg-scanpackages &> /dev/null || ! command -v apt-ftparchive &> /dev/null; then
    echo "Please install dpkg-scanpackages and apt-ftparchive."
    exit 1
fi

# Array of PPAs to update
PPAS=("ti/bookworm")

# Loop through each PPA in the array
for PPA in "${PPAS[@]}"; do
    PPA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$PPA"

    # Check if PPA directory exists
    if [ ! -d "$PPA_DIR" ]; then
        echo "PPA directory $PPA_DIR does not exist, skipping..."
        continue
    fi

    # Change to PPA_DIR so paths in Packages file are relative
    cd "$PPA_DIR" || exit 1

    # Generate Packages and Packages.gz files
    echo "Generating Packages and Packages.gz in $PPA_DIR..."
    dpkg-scanpackages --multiversion . > Packages
    gzip -k -f Packages

    # Generate Release file
    echo "Generating Release file in $PPA_DIR..."
    apt-ftparchive release . > Release

    echo "PPA files updated successfully in $PPA_DIR."
done
