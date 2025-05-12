#!/bin/bash

# Xóa các file g.dart đã có
echo "Cleaning generated files..."
flutter pub run build_runner clean

# Tạo lại các file g.dart
echo "Generating Hive adapter files..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "Build completed!" 