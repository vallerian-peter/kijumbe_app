import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/components/custom_card.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/settings/settings_tile_item.dart';

class SettingsCardGroup extends StatelessWidget {
  final List<SettingsTileItem> tiles;
  final bool isDark;

  const SettingsCardGroup({
    super.key,
    required this.tiles,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF3D3D3D) : Colors.white;

    return CustomCard(
      bgColor: cardBg,
      borderColor: Colors.transparent,
      borderWidth: 0,
      borderRadius: 20,
      padding: EdgeInsets.zero,
      child: Column(
        children: tiles.asMap().entries.map((entry) {
          final isLast = entry.key == tiles.length - 1;
          return Column(
            children: [
              entry.value,
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 64,
                  endIndent: 16,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : AppColors.greyColor,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
