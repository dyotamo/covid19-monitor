---
description: Repository Information Overview
alwaysApply: true
---

# covid19 Information

## Summary
**covid19** is a Flutter-based mobile and web application designed to monitor COVID-19 cases globally and by country. It provides visual data using charts and lists of affected regions.

## Structure
- [./lib/](./lib/): Main application source code.
  - [./lib/src/client/](./lib/src/client/): Contains API client logic for fetching COVID-19 data.
  - [./lib/src/delegate/](./lib/src/delegate/): Search delegate implementation for country lookup.
  - [./lib/src/models/](./lib/src/models/): Data models for countries, global statistics, and reportable entities.
  - [./lib/src/screens/](./lib/src/screens/): UI screens including the main dashboard.
- [./test/](./test/): Contains unit and widget tests for the application.
- [./web/](./web/): Web-specific assets and configuration for Flutter Web support.

## Language & Runtime
- **Language**: Dart
- **Framework**: Flutter
- **Version**: SDK `>=2.7.0 <3.0.0`
- **Build System**: Flutter Build System
- **Package Manager**: pub

## Dependencies
**Main Dependencies**:
- `flutter`: Core Flutter SDK.
- `cupertino_icons`: iOS-style icons.
- `http`: Composable, multi-platform, Future-based API for HTTP requests.
- `intl`: Internationalization and localization support.
- `flutter_svg`: SVG rendering for Flutter.
- `flutter_spinkit`: Loading indicators.
- `font_awesome_flutter`: Font Awesome icon pack.
- `pie_chart`: Flutter pie chart widget.

**Development Dependencies**:
- `flutter_test`: Testing framework for Flutter.

## Build & Installation
```bash
# Install dependencies
flutter pub get

# Run the app in debug mode
flutter run

# Build for Web
flutter build web

# Build for Android (APK)
flutter build apk
```

## Testing
- **Framework**: `flutter_test` (based on `test`)
- **Test Location**: [./test/](./test/)
- **Naming Convention**: Files ending in `*_test.dart`
- **Configuration**: Standard Flutter test setup.

**Run Command**:
```bash
flutter test
```
