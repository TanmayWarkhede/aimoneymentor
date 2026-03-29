#!/bin/bash

# ET Money Mentor - Flutter App Setup Script
echo "🤖 Setting up ET Money Mentor..."
echo "================================="

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first:"
    echo "   https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"

# Check Dart
echo "✅ Dart: $(dart --version)"

# Navigate to project
cd "$(dirname "$0")"

echo ""
echo "📦 Installing dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed"

echo ""
echo "🔑 IMPORTANT: Configure API Key"
echo "================================"
echo "To enable AI chat, add your Anthropic API key:"
echo "  File: lib/services/ai_chat_service.dart"
echo "  Line: static const String _apiKey = 'YOUR_ANTHROPIC_API_KEY';"
echo ""
echo "Get your key at: https://console.anthropic.com/"
echo ""
echo "The app works without an API key but AI chat will use offline responses."

echo ""
echo "📱 Available run commands:"
echo "================================"
echo "  flutter run                    # Run on connected device"
echo "  flutter run -d chrome          # Run as web app"
echo "  flutter run -d android         # Run on Android emulator"
echo "  flutter build apk --release    # Build Android APK"
echo "  flutter build ios --release    # Build iOS (Mac only)"
echo ""
echo "🚀 Starting development server..."
echo ""

# Check for connected devices
DEVICES=$(flutter devices 2>&1)
echo "$DEVICES"

echo ""
echo "Run: flutter run"
echo "================================"
echo "✅ Setup complete! Happy coding 🎉"
