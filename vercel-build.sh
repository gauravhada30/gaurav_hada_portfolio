#!/bin/bash

# Exit on error
set -e

echo "Starting Vercel Build Process for Flutter..."

# 1. Install xz if not present (required to extract Flutter)
if ! command -v xz &> /dev/null; then
    echo "Installing xz..."
    yum install -y xz
fi

# 2. Download Flutter SDK (stable version)
FLUTTER_VERSION="3.10.0" # Match pubspec.yaml environment
if [ ! -d "flutter" ]; then
    echo "Downloading Flutter SDK..."
    curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
    tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
    rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
fi

# 3. Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# 4. Run Flutter Doctor to check environment
flutter doctor

# 5. Build Web Release
echo "Building Flutter Web..."
flutter build web --release --no-tree-shake-icons

echo "Build Complete!"
