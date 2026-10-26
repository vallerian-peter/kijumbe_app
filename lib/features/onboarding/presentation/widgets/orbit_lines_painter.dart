import 'package:flutter/material.dart';

/// CustomPainter that renders concentric orbit guide rings
class OrbitLinesPainter extends CustomPainter {
  const OrbitLinesPainter({
    required this.outerRadius,
    required this.innerRadius,
    this.isDark = false,
  });

  final double outerRadius;
  final double innerRadius;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final linePaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.22)
          : Colors.white.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final subtleLinePaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.12)
          : Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Outer Orbit Ring
    canvas.drawCircle(center, outerRadius, linePaint);

    // Inner Orbit Ring
    canvas.drawCircle(center, innerRadius, subtleLinePaint);
  }

  @override
  bool shouldRepaint(covariant OrbitLinesPainter oldDelegate) {
    return oldDelegate.outerRadius != outerRadius ||
        oldDelegate.innerRadius != innerRadius ||
        oldDelegate.isDark != isDark;
  }
}
