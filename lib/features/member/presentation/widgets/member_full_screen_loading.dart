import 'package:flutter/material.dart';
import '../../../../core/core.dart';

/// Full screen loading overlay with descriptive status for operations such as
/// group code verification and joining.
class MemberFullScreenLoading extends StatelessWidget {
  final String title;
  final String description;

  const MemberFullScreenLoading({
    super.key,
    required this.title,
    required this.description,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String description,
    required Future<T> Function() asyncTask,
  }) async {
    // Show full screen dialog
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (_) => MemberFullScreenLoading(
        title: title,
        description: description,
      ),
    );

    try {
      final result = await asyncTask();
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      return result;
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.92),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Glowing Loading Indicator
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.appPrimaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? AppColors.blueSkyStrong : AppColors.appPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: isDark ? Colors.white : AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.45,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
