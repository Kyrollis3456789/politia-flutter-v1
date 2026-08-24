#!/usr/bin/env bash
set -e

echo "==> Downloading and installing Flutter SDK on Vercel..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1 _flutter

export PATH="$PATH:`pwd`/_flutter/bin"

echo "==> Verifying Flutter version..."
flutter --version

echo "==> Enabling web support..."
flutter config --enable-web

echo "==> Getting dependencies..."
flutter pub get

echo "==> Building Flutter Web..."
flutter build web --release --wasm

echo "==> Build complete!"
