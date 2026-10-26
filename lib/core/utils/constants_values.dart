import 'package:flutter/material.dart';

/// Central application constants
abstract class Constants {
  // App
  static const String appName = "Kijumbe";

  // Text Sizes reference
  static const AppTextSizes textSizes = AppTextSizes();

  // Spacing reference
  static const AppSpacing spacing = AppSpacing();
}

/// Standardized typography scale / text sizes across the app
class AppTextSizes {
  const AppTextSizes();

  /// 10.0 - Tiny labels, captions, badges
  static const double xs = 10.0;

  /// 12.0 - Small secondary text, helper text, timestamps
  static const double sm = 12.0;

  /// 14.0 - Standard body text, subtitles, inputs
  static const double md = 14.0;

  /// 16.0 - Body large, primary button labels, list titles
  static const double lg = 16.0;

  /// 18.0 - Subheadings, card titles, prominent labels
  static const double xl = 18.0;

  /// 20.0 - Section titles, modal titles
  static const double xxl = 20.0;

  /// 24.0 - Heading 3, sheet titles
  static const double h3 = 24.0;

  /// 28.0 - Heading 2, page headers
  static const double h2 = 28.0;

  /// 32.0 - Heading 1, splash title, welcome title
  static const double h1 = 32.0;

  /// 40.0 - Large display / hero banners
  static const double display = 40.0;
}

/// Standardized spacing scale, gaps, and insets across the app
class AppSpacing {
  const AppSpacing();

  // Numerical Spacing Scale
  static const double none = 0.0;
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 48.0;

  // Horizontal Gap Widgets
  static const SizedBox gapW4 = SizedBox(width: xs);
  static const SizedBox gapW8 = SizedBox(width: sm);
  static const SizedBox gapW12 = SizedBox(width: 12.0);
  static const SizedBox gapW16 = SizedBox(width: md);
  static const SizedBox gapW20 = SizedBox(width: 20.0);
  static const SizedBox gapW24 = SizedBox(width: lg);
  static const SizedBox gapW32 = SizedBox(width: xl);

  // Vertical Gap Widgets
  static const SizedBox gapH4 = SizedBox(height: xs);
  static const SizedBox gapH8 = SizedBox(height: sm);
  static const SizedBox gapH12 = SizedBox(height: 12.0);
  static const SizedBox gapH16 = SizedBox(height: md);
  static const SizedBox gapH20 = SizedBox(height: 20.0);
  static const SizedBox gapH24 = SizedBox(height: lg);
  static const SizedBox gapH32 = SizedBox(height: xl);
  static const SizedBox gapH40 = SizedBox(height: xxl);
  static const SizedBox gapH48 = SizedBox(height: xxxl);

  // Padding / Inset Presets
  static const EdgeInsets paddingZero = EdgeInsets.zero;
  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
}
