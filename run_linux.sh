#!/bin/bash
echo "=== EduCam AI ==="
echo "Launching EduCam AI application..."
echo ""

APP_DIR="$(dirname "$0")"
"$APP_DIR/build/linux/x64/debug/bundle/educam_ai"
