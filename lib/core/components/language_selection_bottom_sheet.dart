import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../core.dart';

/// Modal bottom sheet for choosing application language with right-aligned radio buttons.
/// Automatically highlights the currently active locale and updates [LocaleManager].
class LanguageSelectionBottomSheet {
  /// Opens the unified language selection bottom sheet.
  /// Returns the newly selected [Locale] or `null` if dismissed without change.
  static Future<Locale?> show(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomBottomSheet.show<Locale>(
      context,
      bgColor: isDark ? AppColors.darkGreyColor : theme.colorScheme.surface,
      showDragHandle: true,
      showCloseButton: true,
      child: const LanguageSelectionContent(),
    );
  }
}

/// Content widget for the language selection sheet.
class LanguageSelectionContent extends StatefulWidget {
  const LanguageSelectionContent({super.key});

  @override
  State<LanguageSelectionContent> createState() =>
      _LanguageSelectionContentState();
}

class _LanguageSelectionContentState extends State<LanguageSelectionContent> {
  late Locale _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = LocaleManager.instance.currentLocale;
  }

  Future<void> _handleSelect(Locale locale) async {
    setState(() {
      _selectedLocale = locale;
    });

    await LocaleManager.instance.setLocale(locale);

    if (mounted) {
      Navigator.of(context).pop(locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;
    final effectivePrimary =
        isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor;

    final languages = [
      _LanguageOption(
        locale: AppLocales.english,
        name: 'English',
        nativeName: 'English (EN)',
        flag: AppLocales.getLanguageFlag('en'),
      ),
      _LanguageOption(
        locale: AppLocales.swahili,
        name: 'Kiswahili',
        nativeName: 'Swahili (SW)',
        flag: AppLocales.getLanguageFlag('sw'),
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: effectivePrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Iconsax.language_square_outline,
                color: effectivePrimary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.selectLanguage,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: isDark ? Colors.white : AppColors.blackColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.chooseLanguageSubtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Language List with right-aligned Radio
        ...languages.map((lang) {
          final isSelected =
              _selectedLocale.languageCode == lang.locale.languageCode;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? effectivePrimary.withValues(alpha: isDark ? 0.18 : 0.08)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.grey.shade50),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? effectivePrimary
                    : (isDark ? Colors.white12 : Colors.grey.shade200),
                width: isSelected ? 1.8 : 1.0,
              ),
            ),
            child: InkWell(
              onTap: () => _handleSelect(lang.locale),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 14.0),
                child: Row(
                  children: [
                    // Flag icon badge
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        lang.flag,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Language Titles
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.name,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang.nativeName,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Radio indicator at the right
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? effectivePrimary
                              : (isDark ? Colors.white38 : Colors.grey.shade400),
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(3.5),
                      child: isSelected
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: effectivePrimary,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 8),
      ],
    );
  }
}

class _LanguageOption {
  final Locale locale;
  final String name;
  final String nativeName;
  final String flag;

  const _LanguageOption({
    required this.locale,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}
