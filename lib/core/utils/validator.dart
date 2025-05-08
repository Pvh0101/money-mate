class Validator {
  static bool isPasswordCompliant(String password, {
    bool checkLength = true,
    int minLength = 8,
    bool checkSymbolOrNumber = true,
  }) {
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

  static String? validatePasswordComplexity(String? password, {int minLength = 8}) {
    if (password == null || password.isEmpty) {
      return 'Password is required.';
    }
    if (password.length < minLength) {
      return 'Password must be at least $minLength characters.';
    }
    if (!RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must contain a symbol or a number.';
    }
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password.';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match.';
    }
    return null;
  }

  static String? validateEmailField(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required.';
    }
    if (!isValidEmail(email)) { 
      return 'Invalid email format.';
    }
    return null;
  }
} 