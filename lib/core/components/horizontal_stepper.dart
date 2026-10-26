import 'package:flutter/material.dart';
import '../utils/colors.dart';

/// A sleek, segmented horizontal progress stepper matching modern fintech designs.
/// Shows step label and "X of Y" counter with animated segmented bars.
class HorizontalStepper extends StatelessWidget {
  const HorizontalStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabel = 'Step',
    this.title,
    this.showText = true,
    this.height = 5.0,
    this.spacing = 8.0,
    this.borderRadius = 4.0,
    this.activeColor,
    this.inactiveColor,
  }) : assert(currentStep >= 1 && currentStep <= totalSteps);

  final int currentStep;
  final int totalSteps;
  final String stepLabel;
  final String? title;
  final bool showText;
  final double height;
  final double spacing;
  final double borderRadius;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color effectiveActive = activeColor ??
        (isDark ? AppColors.darkModePrimaryColor : theme.colorScheme.primary);
    final Color effectiveInactive = inactiveColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.12)
            : const Color(0xFFE5EDE9));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showText) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title ?? stepLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: effectiveActive,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                '$currentStep of $totalSteps',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: effectiveActive,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: List.generate(totalSteps, (index) {
            final stepNumber = index + 1;
            final isCompletedOrCurrent = stepNumber <= currentStep;

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < totalSteps - 1 ? spacing : 0,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: height,
                  decoration: BoxDecoration(
                    color: isCompletedOrCurrent
                        ? effectiveActive
                        : effectiveInactive,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
