# 🤖 ET Money Mentor — AI-Powered Personal Finance App

> India's first AI-powered personal finance mentor. Makes financial planning as accessible as checking WhatsApp.

---

## 📱 Features

| Module | Description |
|--------|-------------|
| 🔥 **FIRE Planner** | Month-by-month retirement roadmap with corpus charts |
| ❤️ **Money Health Score** | 5-minute checkup across 6 financial dimensions |
| 🎯 **Life Event Advisor** | Bonus, marriage, baby, job change financial guidance |
| 💰 **Tax Wizard** | Old vs New regime comparison, missed deductions finder |
| 👫 **Couples Planner** | Joint HRA, SIP splits, insurance optimization |
| 📊 **MF X-Ray** | XIRR, overlap analysis, AI rebalancing plan |
| 🤖 **AI Chat** | Claude-powered personal finance Q&A |

---

## 🚀 Quick Start

### Prerequisites

```bash
# 1. Install Flutter SDK (3.16+)
# Download from: https://docs.flutter.dev/get-started/install

# Verify installation
flutter doctor

# 2. Install Android Studio or Xcode
# Android: https://developer.android.com/studio
# iOS: Xcode from Mac App Store

# 3. Set up an emulator or connect physical device
```

### Installation

```bash
# Clone / extract project
cd ai_money_mentor

# Install dependencies
flutter pub get

# Run on Android
flutter run

# Run on iOS (macOS only)
flutter run --target-platform ios

# Run on Chrome (web)
flutter run -d chrome

# Build release APK (Android)
flutter build apk --release

# Build release IPA (iOS)
flutter build ios --release
```

---

## 🔑 API Configuration

### Anthropic Claude API (AI Chat feature)

1. Get your API key from: https://console.anthropic.com/
2. Open `lib/services/ai_chat_service.dart`
3. Replace:
   ```dart
   static const String _apiKey = 'YOUR_ANTHROPIC_API_KEY';
   ```
   with your actual API key.

> **Production**: Store API key in `--dart-define` or a secure backend proxy. Never commit keys to git.

```bash
# Run with API key via dart-define (secure)
flutter run --dart-define=ANTHROPIC_API_KEY=sk-ant-xxxxx
```

---

## 🌐 Real Data Sources Used

| Data | Source | API |
|------|--------|-----|
| Mutual Fund NAV | mfapi.in | Free, no key |
| MF Search | api.mfapi.in/mf/search | Free |
| Market Indices | Yahoo Finance | Free |
| World Bank Inflation | api.worldbank.org | Free |
| FD Rates | Curated from bank websites | Static |
| Govt Scheme Rates | RBI / Ministry of Finance | Static |

---

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── router/
│   └── app_router.dart          # GoRouter navigation
├── theme/
│   └── app_theme.dart           # Colors, fonts, themes
├── models/
│   └── models.dart              # Data models (User, MF, Tax, etc.)
├── services/
│   ├── financial_data_service.dart  # Real-time data + calculators
│   ├── ai_chat_service.dart         # Claude AI integration
│   └── notification_service.dart   # Push notifications
├── screens/
│   ├── onboarding/              # Splash + Onboarding
│   ├── auth/                    # Login screen
│   ├── home/                    # Dashboard
│   ├── fire_planner/            # FIRE calculator + charts
│   ├── money_health/            # Health score + radar
│   ├── life_events/             # Event-based guidance
│   ├── tax_wizard/              # Tax regime comparison
│   ├── couples_planner/         # Joint financial planning
│   ├── mf_xray/                 # Portfolio analysis
│   └── chat/                    # AI chat interface
└── widgets/
    └── market_ticker.dart        # Shared UI components
```

---

## 💡 Key Technical Decisions

### Why Flutter?
- Single codebase for Android + iOS + Web
- High performance (compiled to native)
- Rich UI components with animations

### Real-time Data Strategy
- **MF API** (api.mfapi.in): Free, reliable, updated daily
- **Yahoo Finance**: For Sensex/Nifty real-time quotes  
- **Fallback mocks**: Graceful degradation when APIs fail
- No paid subscriptions required for core features

### Tax Calculations
- FY 2024-25 slabs hardcoded (update annually)
- Old Regime: Standard deduction ₹50K
- New Regime: Standard deduction ₹75K (Budget 2024)
- 87A rebate logic for both regimes

### FIRE Math
- Uses compound interest: FV = PV(1+r)^n + PMT × ((1+r)^n - 1) / r
- 4% safe withdrawal rate (Trinity Study adapted for India)
- Inflation-adjusted future value

---

## 📊 Financial Calculators

All calculators use real formulas:

```dart
// SIP Returns
FV = PMT × ((1 + r)^n - 1) / r × (1 + r)
// where r = monthly rate, n = months, PMT = monthly SIP

// XIRR - Newton-Raphson iteration
// Solves: Σ Ci / (1+rate)^(ti) = 0

// EMI
EMI = P × r × (1+r)^n / ((1+r)^n - 1)

// HRA Exemption = min(Actual HRA, 50%/40% of basic, rent - 10% basic)
```

---

## 🔧 Configuration

### `pubspec.yaml` Key Dependencies
- `fl_chart`: Pie, line, bar charts
- `go_router`: Navigation
- `flutter_riverpod`: State management
- `http/dio`: API calls
- `hive`: Local database
- `file_picker`: CAMS/KFintech upload

---

## 🛠️ Troubleshooting

```bash
# Clean build artifacts
flutter clean && flutter pub get

# Fix Android build
cd android && ./gradlew clean && cd ..

# Update dependencies
flutter pub upgrade

# Check for dependency conflicts
flutter pub deps

# Run in verbose mode
flutter run -v
```

---

## 📋 Compliance Notes

- This app provides **general financial education**, not SEBI-registered investment advice
- Always recommend consulting a SEBI-registered advisor for large investment decisions
- Tax calculations based on FY 2024-25 rules — update annually
- Market data is for **informational purposes** only

---

## 🎯 Roadmap

- [ ] Firebase Authentication (OTP login)
- [ ] CAMS statement PDF parser
- [ ] NSE/BSE real-time WebSocket
- [ ] UPI-based SIP tracking
- [ ] Net worth auto-sync (AA framework)
- [ ] Push notifications for SIP reminders
- [ ] Hindi language support

---

## 👨‍💻 Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter 3.x (Dart) |
| State | Riverpod |
| Navigation | GoRouter |
| Charts | fl_chart + syncfusion |
| AI | Anthropic Claude API |
| Local DB | Hive |
| HTTP | http + dio |

---

*Built for ET (Economic Times) Money Mentor Hackathon*
*Inspired by economictimes.com and avataar.ai*
