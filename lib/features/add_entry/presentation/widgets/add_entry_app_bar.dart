import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddEntryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackTap;

  const AddEntryAppBar({super.key, this.onBackTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppBar(
      elevation: 0,
      backgroundColor:
          colorScheme.background, // Hoặc surface nếu có content scroll dưới nó
      leadingWidth: 72, // Để có padding trái cho nút back
      leading: Center(
        child: InkWell(
          onTap: onBackTap ?? () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10.0), // Tăng padding để dễ tap
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: SvgPicture.asset(
              'assets/icons/chevron_left.svg',
              colorFilter: ColorFilter.mode(
                colorScheme.outline,
                BlendMode.srcIn,
              ),
              width:
                  20, // Kích thước icon theo Figma (nút back là 24x24, icon bên trong có thể nhỏ hơn)
              height: 20,
            ),
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        'Add',
        style: textTheme.titleLarge,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
