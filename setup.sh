#!/bin/bash
# EduCam AI Setup Script
# Run: chmod +x setup.sh && ./setup.sh

set -e

echo "============================================"
echo "  EduCam AI - Setup Script"
echo "============================================"
echo ""

# 1. Backend setup
echo "[1/4] Setting up backend..."
cd server
cp .env.example .env 2>/dev/null || true
npm install
echo "  ✓ Backend dependencies installed"
echo "  ⚠ Edit server/.env with your API keys before running"
cd ..

# 2. Flutter setup
echo "[2/4] Setting up Flutter frontend..."
flutter pub get
echo "  ✓ Flutter dependencies installed"

# 3. Generate Android platform if missing
echo "[3/4] Ensuring Android platform..."
if [ ! -d "android" ]; then
  flutter create --platforms=android --project-name=educam_ai . 2>/dev/null
  echo "  ✓ Android platform generated"
else
  echo "  ✓ Android platform exists"
fi

# 4. Build APK
echo "[4/4] Building debug APK..."
flutter build apk --debug --split-per-abi
echo ""
echo "============================================"
echo "  ✅ Build complete!"
echo "============================================"
echo ""
echo "APK files:"
echo "  arm64-v8a: build/app/outputs/flutter-apk/app-arm64-v8a-debug.apk"
echo "  armeabi-v7a: build/app/outputs/flutter-apk/app-armeabi-v7a-debug.apk"
echo "  x86_64: build/app/outputs/flutter-apk/app-x86_64-debug.apk"
echo ""
echo "To start the backend:"
echo "  cd server && npm run dev"
echo ""
echo "To configure backend API URL in Flutter:"
echo "  Edit lib/services/api_client.dart - change _defaultBaseUrl"
echo ""
