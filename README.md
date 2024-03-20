# genievision

Flutter based app for generative text as well as image explanation and story telling.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## deployment

### app key

```bash
keytool -genkeypair -v -keystore app_key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias app_key
```

### android/build.gradle

```bash
buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
signingConfigs {
  release {
      storeFile file("../../app_key.keystore")
      storePassword "xxxxx"
      keyAlias "app_key"
      keyPassword "xxxxx"
  }
}
```
