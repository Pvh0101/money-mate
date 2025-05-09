import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import SvgPicture
import 'package:money_mate/core/theme/app_colors.dart'; // Import app_colors

class LatestEntryItem extends StatelessWidget {
  final String iconPath; // Thay Widget iconWidget bằng String iconPath
  final String category;
  final String date;
  final String amount;
  final String paymentMethod;
  final VoidCallback? onTap; // Thêm onTap callback

  const LatestEntryItem({
    super.key,
    required this.iconPath,
    required this.category,
    required this.date,
    required this.amount,
    required this.paymentMethod,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Xác định xem amount là thu nhập hay chi tiêu dựa vào dấu '+' hoặc '-'
    // Điều này có thể cần logic phức tạp hơn nếu format amount thay đổi
    final bool isIncome = amount.startsWith('+');
    Color effectiveAmountColor = isIncome
        ? systemGreen // Sử dụng systemGreen cho income
        : colorScheme.onSurface;
    if (colorScheme.brightness == Brightness.dark && isIncome) {
      // Figma không có màu income riêng biệt rõ ràng cho dark mode list item
      // Giữ nguyên onSurface cho dark income để đồng bộ, hoặc có thể dùng một màu xanh lá cây tối hơn nếu có
      effectiveAmountColor =
          colorScheme.onSurface; // Hoặc một màu xanh lá cây tối khác
    }

    final iconSvgColor = colorScheme.brightness == Brightness.light
        ? colorScheme.onSurface // Light mode: #242D35 (neutralDark1)
        : colorScheme
            .onSecondaryContainer; // Dark mode: #FAFAFB (neutralSoftGrey3)

    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(8.0), // Bo tròn nhẹ cho hiệu ứng ripple
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 8.0), // Padding nhẹ cho mỗi item để tăng vùng chạm
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Căn giữa theo chiều dọc
          children: [
            // Left side: Icon + Category/Date
            Expanded(
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Căn giữa icon và text
                children: [
                  Container(
                    width: 48, // Figma: Icon container 48x48 (hoặc 44x44)
                    height: 48,
                    padding: const EdgeInsets.all(
                        10.0), // Padding cho icon bên trong
                    decoration: BoxDecoration(
                      color: colorScheme
                          .secondaryContainer, // Bỏ .withOpacity(0.3)
                      borderRadius: BorderRadius.circular(
                          12.0), // Figma: borderRadius 12px
                    ),
                    child: SvgPicture.asset(
                      iconPath,
                      colorFilter:
                          ColorFilter.mode(iconSvgColor, BlendMode.srcIn),
                      width: 24, // Kích thước icon
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 14.0), // Figma: Khoảng cách 14px
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Căn giữa text trong Column
                      children: [
                        Text(
                          category,
                          style: textTheme
                              .titleMedium, // Sử dụng titleMedium từ theme
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0), // Figma: Khoảng cách 4px
                        Text(
                          date,
                          style: textTheme
                              .bodyMedium, // Sử dụng bodyMedium từ theme
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16), // Khoảng cách giữa 2 phần
            // Right side: Amount + Payment Method
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment:
                  MainAxisAlignment.center, // Căn giữa text trong Column
              children: [
                Text(
                  amount,
                  style: textTheme.titleMedium
                      ?.copyWith(color: effectiveAmountColor),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0), // Figma: Khoảng cách 4px
                Text(
                  paymentMethod,
                  style: textTheme.bodyMedium, // Sử dụng bodyMedium từ theme
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
