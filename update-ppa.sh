#!/bin/bash

# Script to update PPA files after adding a new .deb package

# Check if dpkg-scanpackages and apt-ftparchive are installed
if ! command -v dpkg-scanpackages &> /dev/null || ! command -v apt-ftparchive &> /dev/null; then
    echo "Please install dpkg-scanpackages and apt-ftparchive."
    exit 1
fi

# Set PPA_DIR to the directory where this script is located
PPA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to PPA_DIR so paths in Packages file are relative
cd "$PPA_DIR" || exit 1

# Generate Packages and Packages.gz files
echo "Generating Packages and Packages.gz..."
dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages

# Generate Release file
echo "Generating Release file..."
apt-ftparchive release . > Release

echo "PPA files updated successfully."

