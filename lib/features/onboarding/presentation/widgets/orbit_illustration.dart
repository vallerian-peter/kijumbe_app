import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';
import 'orbit_lines_painter.dart';
import 'satellite_badge.dart';

/// Orbit illustration widget displaying concentric rings, center hero, and 6 orbiting satellite badges
class OrbitIllustration extends StatelessWidget {
  const OrbitIllustration({
    super.key,
    required this.diameter,
    this.controller,
  });

  final double diameter;
  final AnimationController? controller;

  // 6 icons around the orbit
  static const List<SatelliteData> satellites = [
    // Top-Left (Phone / Wallet) ~140°
    SatelliteData(
      angleInDegrees: -140,
      iconPath: AppAssets.moneyTransfer,
    ),
    // Top-Right (Handshake) ~ -40°
    SatelliteData(
      angleInDegrees: -40,
      iconPath: AppAssets.successfulHandshake,
    ),
    // Right (Invest Box / Pie chart) ~ 0°
    SatelliteData(
      angleInDegrees: 5,
      iconPath: AppAssets.investBox,
    ),
    // Bottom-Right (Safe / Cash Receive) ~ 50°
    SatelliteData(
      angleInDegrees: 55,
      iconPath: AppAssets.safe,
    ),
    // Bottom-Left (Financial Profit Chart Up) ~ 130°
    SatelliteData(
      angleInDegrees: 130,
      iconPath: AppAssets.financialProfitArrowUp,
    ),
    // Left (Piggy Bank) ~ 180°
    SatelliteData(
      angleInDegrees: 180,
      iconPath: AppAssets.piggyBank,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final orbitRadius = diameter * 0.44;
    final innerOrbitRadius = diameter * 0.28;
    final centerCircleRadius = diameter * 0.23;
    final badgeSize = math.max(46.0, diameter * 0.16);

    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Concentric Orbit Lines Painter
          CustomPaint(
            size: Size(diameter, diameter),
            painter: OrbitLinesPainter(
              outerRadius: orbitRadius,
              innerRadius: innerOrbitRadius,
            ),
          ),

          // Center Circular Hero Graphic (Money Bag)
          Container(
            width: centerCircleRadius * 2,
            height: centerCircleRadius * 2,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.appPrimaryColor.withValues(alpha: 0.12),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: EdgeInsets.all(centerCircleRadius * 0.22),
            child: Center(
              child: Image.asset(
                AppAssets.moneyBag,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    color: AppColors.appPrimaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 48,
                      color: AppColors.appPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 6 Satellite Badges along the Outer Orbit
          ...satellites.map((data) {
            final angleRad = data.angleInDegrees * (math.pi / 180.0);
            final xOffset = orbitRadius * math.cos(angleRad);
            final yOffset = orbitRadius * math.sin(angleRad);

            return Transform.translate(
              offset: Offset(xOffset, yOffset),
              child: SatelliteBadge(
                iconPath: data.iconPath,
                size: badgeSize,
              ),
            );
          }),
        ],
      ),
    );
  }
}
