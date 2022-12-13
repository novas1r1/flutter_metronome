# example

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

echo "ANDROID_NDK=~/Library/Android/sdk/ndk-bundle" >> ~/.gradle/gradle.properties

https://cjycode.com/flutter_rust_bridge/template/tour_gradle.html

flutter_rust_bridge_codegen \
    -r metronome/src/api.rs \
    -d lib/bridge_generated.dart \
    -c ios/Runner/bridge_generated.h \
    -c macos/Runner/bridge_generated.h 