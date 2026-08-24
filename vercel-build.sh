#!/usr/bin/env bash
set -e

echo "==> Downloading and installing Flutter SDK on Vercel..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1 _flutter

export PATH="$PATH:`pwd`/_flutter/bin"

echo "==> Verifying Flutter version..."
flutter --version

echo "==> Enabling web support..."
flutter config --enable-web

echo "==> Ensuring .env exists..."
if [ ! -f .env ]; then
  echo "Creating default .env from .env.example..."
  cp .env.example .env
fi

echo "==> Getting dependencies..."
flutter pub get

echo "==> Building Flutter Web..."
flutter build web --release

echo "==> Build complete!"
