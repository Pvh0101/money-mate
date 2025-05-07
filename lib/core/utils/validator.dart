class Validator {
  static bool isPasswordCompliant(String password, {
    bool checkNameOrEmail = true, // Giả định tên người dùng hoặc một phần email
    String? nameOrEmailSubstring, // Ví dụ: 'fisher'
    bool checkLength = true,
    int minLength = 8,
    bool checkSymbolOrNumber = true,
  }) {
    if (checkNameOrEmail && nameOrEmailSubstring != null && password.toLowerCase().contains(nameOrEmailSubstring.toLowerCase())) {
      return false; // Không được chứa tên hoặc email
    }
    if (checkLength && password.length < minLength) {
      return false; // Không đủ độ dài
    }
    if (checkSymbolOrNumber && !RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return false; // Không chứa ký hiệu hoặc số
    }
    return true;
  }

  static bool containsNameOrEmail(String password, String? nameOrEmailSubstring) {
    if (nameOrEmailSubstring == null) return false;
    return password.toLowerCase().contains(nameOrEmailSubstring.toLowerCase());
  }

  static bool hasMinLength(String password, {int minLength = 8}) {
    return password.length >= minLength;
  }

  static bool containsSymbolOrNumber(String password) {
    return RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  // Thêm các hàm validate khác ở đây (ví dụ: email, notEmpty, ...)
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    // Biểu thức chính quy đơn giản để kiểm tra email
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  static bool isNotEmpty(String? text) {
    return text != null && text.isNotEmpty;
  }
} 