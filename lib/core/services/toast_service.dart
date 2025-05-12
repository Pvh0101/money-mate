import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType {
  success,
  error,
  warning,
  info,
}

class ToastService {
  void show({
    required String message,
    ToastType type = ToastType.info,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color? backgroundColor,
    Color? textColor,
    double fontSize = 16.0,
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    Color bg;
    Color fg;

    switch (type) {
      case ToastType.success:
        bg = Colors.green;
        fg = Colors.white;
        break;
      case ToastType.error:
        bg = Colors.red;
        fg = Colors.white;
        break;
      case ToastType.warning:
        bg = Colors.orange;
        fg = Colors.black;
        break;
      case ToastType.info:
      default:
        bg = Colors.black87;
        fg = Colors.white;
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: 1, // Mặc định cho iOS và Web
      backgroundColor: backgroundColor ?? bg,
      textColor: textColor ?? fg,
      fontSize: fontSize,
    );
  }

  // Có thể thêm các phương thức tiện ích khác ở đây nếu cần
  // void showError(String message) => show(message: message, type: ToastType.error);
  // void showSuccess(String message) => show(message: message, type: ToastType.success);
}
