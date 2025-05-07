import 'package:flutter/material.dart';
import 'package:money_mate/core/theme/app_colors.dart'; // Giả sử bạn có file này

enum AppTextFieldSize { small, medium, large }

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText; // Nhãn hiển thị bên trên TextFormField
  final String? hintText;  // Placeholder bên trong TextFormField
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final String? errorText;
  final AppTextFieldSize size;
  final bool filled; // true = filled (nền trắng), false = outlined (nền xám nhạt)
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final AutovalidateMode? autovalidateMode;
  final String? restorationId;
  final bool readOnly;

  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.errorText,
    this.size = AppTextFieldSize.medium,
    this.filled = false, // Theo Figma, "Filled=off" có nền xám F5F6F7
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.autovalidateMode,
    this.restorationId,
    this.readOnly = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      // Chỉ dispose nếu FocusNode được tạo nội bộ
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus != _isFocused) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case AppTextFieldSize.small:
        return 32.0;
      case AppTextFieldSize.medium:
        return 40.0;
      case AppTextFieldSize.large:
        return 48.0;
    }
  }

  double _getBorderRadius() {
    switch (widget.size) {
      case AppTextFieldSize.small:
        return 10.0;
      case AppTextFieldSize.medium:
        return 12.0;
      case AppTextFieldSize.large:
        return 14.0;
    }
  }

  EdgeInsets _getContentPadding(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool hasPrefix = widget.prefixIcon != null;
    bool hasSuffix = widget.suffixIcon != null;

    // Figma padding: 12px 16px cho size 48, 8px 16px cho size 40 & 32
    // Flutter contentPadding bao gồm không gian cho cả prefix/suffix icon
    // Nên padding ngang có thể cần điều chỉnh một chút
    double verticalPadding;
    double horizontalPadding = 16.0;

    switch (widget.size) {
      case AppTextFieldSize.small:
        verticalPadding = 8.0;
        break;
      case AppTextFieldSize.medium:
        verticalPadding = 8.0; // Figma size 40px
        break;
      case AppTextFieldSize.large:
        verticalPadding = 12.0; // Figma size 48px
        break;
    }
    
    // Căn chỉnh text và icon bên trong field
    // Nếu chỉ có text, padding dọc cần đảm bảo text ở giữa
    // Nếu có icon, icon cũng cần được căn giữa
    // ThemeData của Material 3 có thể đã xử lý vụ này khá tốt với prefixIconConstraints và suffixIconConstraints

    return EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding);
  }

  TextStyle _getTextStyle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Dựa trên style_VI5QUV và style_305F3L từ Figma
    // style_VI5QUV: Inter 400, 16px, lineHeight 1.5 (24px), letterSpacing 2%
    // style_305F3L: Inter 400, 14px, lineHeight 1.428 (20px), letterSpacing 2%
    
    // Lấy textTheme từ AppTheme đã được apply
    // Chúng ta cần một text style phù hợp từ theme, ví dụ bodyMedium hoặc bodyLarge
    // và điều chỉnh fontSize nếu cần
    
    TextStyle baseStyle = theme.textTheme.bodyLarge ?? const TextStyle(fontFamily: 'Inter'); // Hoặc bodyMedium

    double fontSize;
    // double lineHeightMultiplier; // Figma dùng em, Flutter dùng multiplier trên fontSize

    switch (widget.size) {
      case AppTextFieldSize.small:
        fontSize = 14.0;
        // lineHeightMultiplier = 1.4285714285714286;
        baseStyle = theme.textTheme.bodyMedium ?? baseStyle;
        break;
      case AppTextFieldSize.medium:
      case AppTextFieldSize.large:
        fontSize = 16.0;
        // lineHeightMultiplier = 1.5;
        break;
    }
    
    // Figma letterSpacing: 2%
    // Flutter letterSpacing: fontSize * 0.02
    
    // Màu text sẽ được quyết định bởi InputDecorationTheme hoặc trực tiếp trong decoration
    return baseStyle.copyWith(
        fontSize: fontSize,
        // height: lineHeightMultiplier, // Cẩn thận khi set height, có thể làm lệch text
        letterSpacing: fontSize * 0.02,
        color: widget.enabled ? neutralDark1 : neutralGrey1 // Màu cơ bản khi nhập text
      );
  }
  
  TextStyle _getHintStyle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Figma label_1 (Example placeholder): màu #9BA1A8 (neutralGrey1 hoặc tương tự)
    // Cùng font size và line height với text chính
    TextStyle baseStyle = theme.textTheme.bodyLarge ?? const TextStyle(fontFamily: 'Inter');
     double fontSize;

    switch (widget.size) {
      case AppTextFieldSize.small:
        fontSize = 14.0;
         baseStyle = theme.textTheme.bodyMedium ?? baseStyle;
        break;
      case AppTextFieldSize.medium:
      case AppTextFieldSize.large:
        fontSize = 16.0;
        break;
    }
    
    return baseStyle.copyWith(
      fontSize: fontSize,
      letterSpacing: fontSize * 0.02,
      color: neutralGrey1, // Màu cho hint text
    );
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final borderRadius = _getBorderRadius();
    final fieldHeight = _getHeight(); // TextFormField sẽ cố gắng vừa với height này qua contentPadding và constraints
    final textStyle = _getTextStyle(context);
    final hintStyle = _getHintStyle(context);

    // Màu sắc dựa trên trạng thái
    Color borderColor = widget.filled ? Colors.transparent : neutralSoftGrey1; // stroke_RR5YST (#DCDFE3)
    Color fillColor = widget.filled ? neutralWhite : const Color(0xFFF5F6F7); // fill_03EN7V
    double borderWidth = 1.0;
    
    // BoxShadow cho focus/error
    BoxShadow? activeBoxShadow;


    if (!widget.enabled) {
      // Màu khi disabled
      // Figma: label_1 (text) màu #B0B8BF (neutralGrey2/RXUH0D)
      // Figma: icon màu #B0B8BF
      // Figma: nền vẫn là #F5F6F7 cho "Filled=off, State=disabled"
      // Figma: nền là #F5F6F7 cho "Filled=on, State=disabled"
      fillColor = const Color(0xFFF5F6F7); // Luôn là màu này khi disabled
      borderColor = widget.filled ? Colors.transparent : neutralSoftGrey1; // Giữ nguyên border cho outlined
    } else if (widget.errorText != null && widget.errorText!.isNotEmpty) {
      // Màu khi có lỗi
      // Figma stroke_7YV6WY: #EF4E4E (systemRed)
      // Figma effect_KUEI89: boxShadow: 0px 0px 0px 2px rgba(239, 78, 78, 0.2)
      borderColor = systemRed;
      // Theo Figma, khi error, nền là #FFFFFF (trắng) cho cả Filled=on và Filled=off
      fillColor = neutralWhite; 
      activeBoxShadow = BoxShadow(
          color: systemRed.withValues(alpha: 0.2),
          spreadRadius: 2, // Tương đương với việc set 0px 0px 0px 2px trong Figma
          blurRadius: 0, 
          offset: const Offset(0,0)
      );
    } else if (_isFocused) {
      // Màu khi focus
      // Figma stroke_EI9UFA: #37ABFF (systemBlue)
      // Figma effect_V4V19A: boxShadow: 0px 0px 0px 2px rgba(24, 144, 255, 0.2)
      borderColor = systemBlue;
      // Theo Figma, khi focus, nền là #FFFFFF (trắng) cho cả Filled=on và Filled=off
      fillColor = neutralWhite;
       activeBoxShadow = BoxShadow(
          color: systemBlue.withValues(alpha: 0.2), // Figma: rgba(24, 144, 255, 0.2)
          spreadRadius: 2,
          blurRadius: 0,
          offset: const Offset(0,0)
      );
    }

    InputDecoration decoration = InputDecoration(
      hintText: widget.hintText,
      hintStyle: hintStyle,
      // labelText: widget.labelText, // Sẽ dùng labelText bên ngoài nếu có
      // labelStyle: ... ,
      // floatingLabelStyle: ... ,
      // floatingLabelBehavior: FloatingLabelBehavior.always, // Nếu muốn label luôn ở trên
      
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      
      // Màu sắc icon sẽ lấy từ iconTheme của ThemeData, hoặc có thể set ở đây
      // prefixIconColor: ...,
      // suffixIconColor: ...,

      contentPadding: _getContentPadding(context),
      
      filled: true, // Luôn set true để fillColor có tác dụng
      fillColor: fillColor,
      
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: (widget.errorText != null && widget.errorText!.isNotEmpty) ? systemRed : systemBlue, width: borderWidth),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: systemRed, width: borderWidth),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: systemRed, width: borderWidth),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: widget.filled ? Colors.transparent : neutralSoftGrey1, width: borderWidth),
      ),
      
      errorText: widget.errorText,
      // errorStyle: ...,
      // errorMaxLines: ...,
      
      // Constraints để kiểm soát kích thước của icon
      // prefixIconConstraints: BoxConstraints(minHeight: fieldHeight, minWidth: 40), // Ví dụ
      // suffixIconConstraints: BoxConstraints(minHeight: fieldHeight, minWidth: 40), // Ví dụ

      // Căn chỉnh nội dung bên trong field (bao gồm cả text và icon)
      // isDense: true, // Có thể thử nếu padding mặc định quá lớn
    );

    Widget textField = TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      textCapitalization: widget.textCapitalization,
      style: textStyle,
      decoration: decoration,
      validator: widget.validator,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
      restorationId: widget.restorationId,
      readOnly: widget.readOnly,
      // cursorColor: ...,
      // textAlignVertical: TextAlignVertical.center, // Thử nếu căn chỉnh dọc có vấn đề
    );

    // Box để áp dụng BoxShadow vì InputDecoration không hỗ trợ trực tiếp BoxShadow theo ý muốn
    // (chỉ có thể dùng PhysicalModel hoặc ShapeDecoration nhưng phức tạp hơn)
    // Một cách khác là dùng Stack với Container phía sau có shadow.
    // Hoặc đơn giản là để InputDecoration xử lý border và không có shadow phức tạp như Figma.
    // Hiện tại, tôi sẽ để BoxShadow cho focused/error thông qua màu border được làm nổi bật.
    // Figma có shadow nhẹ, có thể xem xét thêm nếu cần.
    // Nếu muốn shadow chính xác như Figma, cần bọc TextFormField trong một Container có Decoration với shadow đó.
    
    // Wrapper để có thể thêm BoxShadow động
    // Hiện tại, `activeBoxShadow` sẽ không được dùng trực tiếp lên TextFormField mà là
    // thông qua việc thay đổi màu border của InputDecoration.
    // Nếu muốn shadow thực sự, chúng ta cần một cách tiếp cận khác.

    // Đối với labelText bên ngoài:
    if (widget.labelText != null && widget.labelText!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.labelText!,
            // Figma "Income Title": Inter, 600, 16px
            // Nên lấy style từ textTheme, ví dụ titleMedium hoặc custom
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16, color: neutralDark1), 
          ),
          const SizedBox(height: 8.0), // Khoảng cách giữa label và field (Figma là 12px từ baseline label đến top field, nhưng thường 8px là hợp lý)
          // Container để có thể kiểm soát chiều cao chính xác nếu cần
          SizedBox(
            height: fieldHeight, // Chiều cao mong muốn của field
            child: textField,
          ),
        ],
      );
    }

    return SizedBox(
      height: fieldHeight,
      child: textField,
    );
  }
}
