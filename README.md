# Flutter Furniture AR App

This is a Flutter-based augmented reality (AR) app for placing furniture in real-world space using AR features.

## Getting Started

This project is a starting point for a Flutter application with AR integration.

### Helpful Resources:
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Flutter AR packages](https://pub.dev)

---

## Setup Instructions

1. Run `flutter pub get`
2. Add your Firebase config files:
    - `android/app/google-services.json`
    - `ios/Runner/GoogleService-Info.plist`
3. Add your own [ImageKit](https://imagekit.io/) private key if you're using image uploads
4. Run the app on a real device (AR features typically don’t work on emulators)

---

## Features

- AR-based furniture placement
- Firebase Firestore integration
- Image upload via ImageKit
- Clean UI for browsing furniture

---

## Security Notes

- Sensitive files like Firebase keys are excluded via `.gitignore`
- Be sure to keep `google-services.json` and API keys private
