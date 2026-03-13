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

# 3. Fix git safe.directory for root user (Vercel runs as root)
git config --global --add safe.directory "$(pwd)/flutter" 2>/dev/null || true
git config --global --add safe.directory "*" 2>/dev/null || true

# 4. Add Flutter to PATH
export PATH="$PATH:$(pwd)/flutter/bin"

# 5. Disable analytics / prompts and suppress root warning
export PUB_ENVIRONMENT="bot.vercel"
flutter config --no-analytics 2>/dev/null || true

# 6. Enable web
flutter config --enable-web

# 7. Get dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# 8. Build Flutter Web (release)
echo "Building Flutter Web..."
flutter build web --release --no-tree-shake-icons

echo "Build complete! Output is in build/web"
