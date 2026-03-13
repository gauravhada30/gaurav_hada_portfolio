#!/bin/bash

# Exit on error
set -e

echo "Starting Vercel Build Process for Flutter..."

# Flutter stable version that ships with Dart 3.7.2
FLUTTER_VERSION="3.29.3"
FLUTTER_ARCHIVE="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${FLUTTER_ARCHIVE}"

# 1. Install xz-utils if needed (for extracting tar.xz)
echo "Checking dependencies..."
if ! command -v xz &> /dev/null; then
    apt-get install -y xz-utils 2>/dev/null || yum install -y xz 2>/dev/null || true
fi

# 2. Download Flutter SDK
if [ ! -d "flutter" ]; then
    echo "Downloading Flutter SDK ${FLUTTER_VERSION}..."
    curl -sL "${FLUTTER_URL}" -o "${FLUTTER_ARCHIVE}"
    tar xf "${FLUTTER_ARCHIVE}"
    rm "${FLUTTER_ARCHIVE}"
fi

# 3. Add Flutter to PATH
export PATH="$PATH:$(pwd)/flutter/bin"

# 4. Disable analytics / prompts
flutter config --no-analytics

# 5. Enable web
flutter config --enable-web

# 6. Get dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# 7. Build Flutter Web (release)
echo "Building Flutter Web..."
flutter build web --release --no-tree-shake-icons

echo "Build complete! Output is in build/web"
