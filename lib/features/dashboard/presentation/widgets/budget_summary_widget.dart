import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:money_mate/core/theme/app_colors.dart';

class BudgetSummaryWidget extends StatelessWidget {
  final String totalSpentAmountDisplay;
  final double spentPercentageValue;

  const BudgetSummaryWidget({
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
      color: colorScheme.onPrimary,
    );

    final descriptionStyle = textTheme.titleSmall?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 160,
          height: 160,
          child: CustomPaint(
            painter: _SolidCirclePainter(
              baseRingColor: colorScheme.surfaceVariant,
              mainCircleGradient: const LinearGradient(
                colors: [primaryBlueGradientStartFigma, primaryBrandBlue],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.0, 1.0],
              ),
              ellipse2RadiusFactor: 0.92,
              ellipse1RadiusFactor: 0.85,
            ),
            child: Center(
              child: Text(
                totalSpentAmountDisplay,
                style: amountStyle,
              ),
            ),
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

class _SolidCirclePainter extends CustomPainter {
  final Color baseRingColor;
  final Gradient mainCircleGradient;
  final double ellipse2RadiusFactor;
  final double ellipse1RadiusFactor;

  static const double _ellipse3Opacity = 0.3;
  static const double _ellipse2Opacity = 0.5;

  _SolidCirclePainter({
    required this.baseRingColor,
    required this.mainCircleGradient,
    this.ellipse2RadiusFactor = 0.92,
    this.ellipse1RadiusFactor = 0.85,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double maxRadius = math.min(size.width / 2, size.height / 2);

    final paintEllipse3 = Paint()
      ..color = baseRingColor.withOpacity(_ellipse3Opacity);
    canvas.drawCircle(center, maxRadius, paintEllipse3);

    final paintEllipse2 = Paint()
      ..color = baseRingColor.withOpacity(_ellipse2Opacity);
    canvas.drawCircle(center, maxRadius * ellipse2RadiusFactor, paintEllipse2);

    final paintEllipse1 = Paint()
      ..shader = mainCircleGradient.createShader(Rect.fromCircle(
          center: center, radius: maxRadius * ellipse1RadiusFactor));
    canvas.drawCircle(center, maxRadius * ellipse1RadiusFactor, paintEllipse1);
  }

  @override
  bool shouldRepaint(covariant _SolidCirclePainter oldDelegate) {
    return oldDelegate.baseRingColor != baseRingColor ||
        oldDelegate.mainCircleGradient != mainCircleGradient ||
        oldDelegate.ellipse1RadiusFactor != ellipse1RadiusFactor ||
        oldDelegate.ellipse2RadiusFactor != ellipse2RadiusFactor;
  }
}
