import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary Palette (Themed with kijumbe-logo-blue)
  static const Color blueSkyStrong = Color(0xFF0C2A8A);
  static const Color appPrimaryColor = blueSkyStrong;
  static const Color primaryColor = appPrimaryColor;
  static const Color appPrimaryDarkColor = Color(0xFF06176F);
  static const Color appPrimaryLightColor = Color(0xFF1E5EEB);
  // Dark Mode Brand Primary Palette (Soft, accessible, non-glaring blue)
  static const Color darkModePrimaryColor = Color(0xFF5B8DEF);
  static const Color darkModePrimaryLight = Color(0xFF7FA7F4);
  static const Color darkModePrimaryDark = Color(0xFF386DD8);

  /// Helper to get the appropriate primary brand color depending on brightness
  static Color primaryFor(bool isDark) =>
      isDark ? darkModePrimaryColor : appPrimaryColor;

  static const Color appGreyWhite = Color(0xFFF7F9FA);


  // Logo Accent Gold / Yellow
  static const Color appAccentGold = Color(0xFFF1B845);
  static const Color appAccentGoldLight = Color(0xFFFDDA72);

  // Neutral & Functional Colors
  static const Color whiteColor = Color(0xffffffff);
  static const Color blackColor = Color(0xff000000);
  static const Color greyColor = Color(0xfff3f3f3);
  static const Color darkGreyColor = Color(0xFF313131);
  static const Color redColor = Color(0xffff0000);
  static const Color greenColor = Color(0xFF2FC165);
  static const Color yellowColor = Color(0xFFF1B845);
  static const Color amberColor = Color(0xFFF59E0B);
  static const Color amberDark = Color(0xFFB45309);
  static const Color amberLight = Color(0xFFFEF3C7);

  // Soft Sky Blue Tint Colors (for onboarding background)
  static const Color skyBackgroundStart = Color(0xFFDCE8FA);
  static const Color skyBackgroundMid = Color(0xFFEBF2FD);
  static const Color skyBackgroundEnd = Color(0xFFF5F8FE);

  // Backward-compatible aliases for previous mint tint colors
  static const Color mintBackgroundStart = skyBackgroundStart;
  static const Color mintBackgroundMid = skyBackgroundMid;
  static const Color mintBackgroundEnd = skyBackgroundEnd;

  // ==========================================
  // Gradients
  // ==========================================

  /// 1. Soft Sky Blue Onboarding Gradient
  static const LinearGradient skySoftGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      skyBackgroundStart, // Pale sky blue tint (top)
      skyBackgroundMid,   // Subtle transitional tone
      skyBackgroundEnd,   // Crisp soft-blue base (bottom)
    ],
    stops: [0.0, 0.45, 1.0],
  );

  /// Backward-compatible alias for previous mintSoftGradient
  static const LinearGradient mintSoftGradient = skySoftGradient;

  /// 2. Modern Dark Gradient
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2C3034), // Deep charcoal grey
      Color(0xFF1B1E21), // Midnight dark
      Color(0xFF121416), // Pure dark base
    ],
    stops: [0.0, 0.55, 1.0],
  );

  /// 3. Light Grey to White Gradient
  static const LinearGradient lightGreyWhiteGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF), // Pure crisp white
      Color(0xFFF6F7F9), // Subtle light grey
      Color(0xFFEBEEF2), // Border light grey
    ],
    stops: [0.0, 0.65, 1.0],
  );

  /// 4. Primary Brand Blue Gradient (Fintech cards, headers, hero banners)
  static const LinearGradient primaryBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2563EB), // Vibrant royal/sky blue highlight
      Color(0xFF1648CD), // Core brand blue
      Color(0xFF0F36A5), // Softened deep blue (eliminates harsh near-black dropoff)
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Backward-compatible alias for previous primaryTealGradient
  static const LinearGradient primaryTealGradient = primaryBlueGradient;

  /// 5. Dynamic Shine Primary Button Gradient (Gives buttons a sleek, non-static shine)
  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment(-0.2, 0.2), // nearby center
    end: Alignment.topRight,     // right-top
    colors: [
      Color(0xFF1546BD), // Balanced rich primary blue (not deep as 0xFF0C2A8A and not too light)
      Color(0xFF1C54DE), // Core light-primary tone
      Color(0xFF306EFF), // 10% luminous fade-in of light primary towards right-top
    ],
    stops: [0.0, 0.50, 1.0],
  );

  /// 6. Dark Get Started Gradient (Deep, sleek dark onboarding background)
  static const LinearGradient darkGetStartedGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF262A30), // Refined deep slate tone (top)
      Color(0xFF1B1E22), // Midnight charcoal mid
      Color(0xFF121416), // Solid dark base (bottom)
    ],
    stops: [0.0, 0.45, 1.0],
  );

  /// 7. Dark Primary Button Gradient (Balanced, accessible shine for dark mode buttons)
  static const LinearGradient darkPrimaryButtonGradient = LinearGradient(
    begin: Alignment(-0.2, 0.2), // nearby center
    end: Alignment.topRight,     // right-top
    colors: [
      Color(0xFF3F75E4), // Balanced foundation blue
      Color(0xFF5589F0), // Core light-primary tone
      Color(0xFF75A1FC), // 10% luminous fade-in towards right-top
    ],
    stops: [0.0, 0.50, 1.0],
  );

  /// Helper to get the correct primary button gradient depending on brightness
  static LinearGradient primaryButtonGradientFor(bool isDark) =>
      isDark ? darkPrimaryButtonGradient : primaryButtonGradient;
}

