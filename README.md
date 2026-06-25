# daily_schedule_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



<!-- EMULATOR PC -->
$env:GRADLE_USER_HOME = "D:\flutter-projects\daily_schedule_app\scratch\gradle"
$env:ANDROID_HOME = "D:\Android\Sdk"
$env:ANDROID_SDK_ROOT = "D:\Android\Sdk"
$env:TEMP = "D:\flutter-projects\daily_schedule_app\scratch\temp"
$env:TMP = "D:\flutter-projects\daily_schedule_app\scratch\temp"

flutter build apk --debug --target-platform android-x64
flutter run -d emulator-5554 --use-application-binary build\app\outputs\flutter-apk\app-debug.apk


<!-- RUN HP FISIK -->

flutter build apk --debug --target-platform android-arm64
flutter run -d 7dwwiff6ln798lz9 --use-application-binary build\app\outputs\flutter-apk\app-debug.apk