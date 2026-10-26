import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final Color? iconColor;
  final IconData? icon;
  final double? iconSize;
  final EdgeInsets? paddingInset;
  final Color? bgColor;
  final bool? isCircle;
  final double? borderRadius;
  final VoidCallback? onTap;

  const CustomBackButton({
    super.key,
    this.iconColor,
    this.icon,
    this.iconSize,
    this.paddingInset,
    this.bgColor,
    this.isCircle = true,
    this.borderRadius = 12,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap ?? () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      child: Container(
        padding: paddingInset ?? const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.transparent, 
          shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 3),
          child: Icon(
            icon ?? Icons.arrow_back_ios,
            size: iconSize ?? 20,
            color: iconColor ?? (isDark ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
