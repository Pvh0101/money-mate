import 'package:flutter/material.dart';
import 'auth_bottom_indicator.dart';
import 'logo_section.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  final Widget? errorToast;
  
  const AuthLayout({
    super.key,
    required this.child,
    this.errorToast,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        // Logo section
                        const LogoSection(),
                        const SizedBox(height: 52),

                        // Error toast if provided
                        if (errorToast != null) ...[
                          errorToast!,
                          const SizedBox(height: 16),
                        ],
                        
                        // Main content
                        child,

                        const Spacer(),
                        // Bottom indicator
                        const AuthBottomIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 