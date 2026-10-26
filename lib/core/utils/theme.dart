import 'package:flutter/material.dart';
import '/core/core.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Inter',
  colorScheme: ColorScheme.light(
    primary: AppColors.appPrimaryColor,
    secondary: AppColors.whiteColor,
    tertiary: AppColors.blackColor,
    surface: AppColors.whiteColor,
    error: AppColors.redColor,
    onPrimary: AppColors.appPrimaryDarkColor,
    onSecondary: AppColors.appPrimaryLightColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    errorStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.redColor,
      height: 1.3,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.redColor, width: 1.2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.redColor, width: 1.8),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  fontFamily: 'Inter',
  colorScheme: const ColorScheme.dark(
    primary: AppColors.darkModePrimaryColor,
    secondary: AppColors.blackColor,
    tertiary: AppColors.whiteColor,
    surface: AppColors.darkGreyColor,
    error: AppColors.redColor,
    onPrimary: Colors.white,
    onSecondary: AppColors.darkModePrimaryLight,
  ),
  inputDecorationTheme: InputDecorationTheme(
    errorStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.redColor,
      height: 1.3,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.redColor, width: 1.2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.redColor, width: 1.8),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return null;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.darkModePrimaryColor;
      }
      return null;
    }),
  ),
);
