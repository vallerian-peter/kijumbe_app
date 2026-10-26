import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';

/// Circular elevated badge displaying an icon along the orbit ring
class SatelliteBadge extends StatelessWidget {
  const SatelliteBadge({
    super.key,
    required this.iconPath,
    required this.size,
  });

  final String iconPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E242B) : Colors.white,
        shape: BoxShape.circle,
        border: isDark ? Border.all(color: Colors.white12, width: 1.0) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.18),
      child: Center(
        child: Image.asset(
          iconPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.monetization_on_rounded,
            size: 20,
            color: isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor,
          ),
        ),
      ),
    );
  }
}

/// Metadata model for a satellite badge on the orbit
class SatelliteData {
  const SatelliteData({
    required this.angleInDegrees,
    required this.iconPath,
  });

  final double angleInDegrees;
  final String iconPath;
}
