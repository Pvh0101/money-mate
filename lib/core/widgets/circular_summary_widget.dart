import 'package:flutter/material.dart';
import 'package:money_mate/core/theme/app_colors.dart';

class CircularSummaryWidget extends StatelessWidget {
  final String totalSpentAmountDisplay;
  final double spentPercentageValue;

  const CircularSummaryWidget({
    super.key,
    required this.totalSpentAmountDisplay,
    required this.spentPercentageValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final amountStyle = textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    final descriptionStyle = textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    );

    final Color baseRingColor = colorScheme.brightness == Brightness.light
        ? colorScheme.secondaryContainer // Light: neutralSoftGrey2
        : colorScheme.secondaryContainer; // Dark: darkIconSurface (#3E4C59)

    const Gradient mainCircleGradient = LinearGradient(
      colors: [primaryBlueGradientStartFigma, primaryBrandBlue],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [0.0, 1.0],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 160.0, // Hardcoded
          height: 160.0, // Hardcoded
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Ring (largest, most transparent)
              Container(
                width: 160.0 * 1.0, // Hardcoded: size * outerRingRadiusFactor
                height: 160.0 * 1.0, // Hardcoded: size * outerRingRadiusFactor
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseRingColor.withValues(
                      alpha: 0.3), // Hardcoded: outerRingOpacity
                ),
              ),
              // Middle Ring
              Container(
                width: 160.0 * 0.92, // Hardcoded: size * middleRingRadiusFactor
                height:
                    160.0 * 0.92, // Hardcoded: size * middleRingRadiusFactor
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseRingColor.withValues(
                      alpha: 0.5), // Hardcoded: middleRingOpacity
                ),
              ),
              // Main Circle (smallest, with gradient)
              Container(
                width: 160.0 * 0.85, // Hardcoded: size * mainCircleRadiusFactor
                height:
                    160.0 * 0.85, // Hardcoded: size * mainCircleRadiusFactor
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: mainCircleGradient,
                ),
                child: Center(
                  child: Text(
                    totalSpentAmountDisplay,
                    style: amountStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'You have Spend total ${(spentPercentageValue * 100).toInt()}% of your budget',
          style: descriptionStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
