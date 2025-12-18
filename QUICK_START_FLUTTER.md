# ⚡ Quick Start Flutter - Bắt Đầu Nhanh

> **Hướng dẫn nhanh để bắt đầu học Flutter**

---

## 🚀 3 Bước Bắt Đầu

### 1. Cài Flutter (Windows)

```bash
# Tải Flutter SDK từ:
https://docs.flutter.dev/get-started/install/windows

# Giải nén vào: C:\src\flutter
# Thêm vào PATH: C:\src\flutter\bin
```

### 2. Kiểm Tra

```bash
flutter doctor
```

### 3. Tạo Project Đầu Tiên

```bash
flutter create hello_world
cd hello_world
flutter run
```

---

## 📱 Code Trên Mobile

### Android
- **Termux** + Code Server
- **AIDE** - Android IDE
- **FlutLab** - Web-based IDE

### iOS
- **Textastic** - Code Editor
- **Working Copy** - Git + Editor

---

## 📚 Học Dart Trước

1. **Dart Language Tour:** https://dart.dev/guides/language/language-tour
2. **DartPad:** https://dartpad.dev/ (Code online)
3. **Sololearn App:** Học Dart trên mobile

---

## 🎯 Project Đầu Tiên

```dart
// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Hello Flutter')),
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
```

---

## 📖 Tài Nguyên

- **Docs:** https://docs.flutter.dev/
- **YouTube:** https://www.youtube.com/c/flutterdev
- **Codelabs:** https://codelabs.developers.google.com/?cat=Flutter

---

**Xem file `HUONG_DAN_SETUP_FLUTTER_MOBILE.md` để biết chi tiết!**

















