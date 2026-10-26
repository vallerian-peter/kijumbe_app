import 'package:flutter/material.dart';
import 'package:kijumbe_app/core/core.dart';
import 'get_started_screen.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  late Locale _selectedLocale;

  @override
  void initState() {
    super.initState();
    // Default selected from stored locale (or English if first launch)
    _selectedLocale = LocaleManager.instance.currentLocale;
  }

  Future<void> _onSelectLocale(Locale locale) async {
    setState(() {
      _selectedLocale = locale;
    });
    // Dynamically update app locale when selected
    await LocaleManager.instance.setLocale(locale);
  }

  void _onContinue() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GetStartedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    final locales = [
      {
        'locale': AppLocales.english,
        'flag': AppLocales.getLanguageFlag(AppLocales.english.languageCode),
        'name': 'English',
        'nativeName': 'English',
      },
      {
        'locale': AppLocales.swahili,
        'flag': AppLocales.getLanguageFlag(AppLocales.swahili.languageCode),
        'name': 'Kiswahili',
        'nativeName': 'Swahili',
      },
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Decorative icon badge
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.language_rounded,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                l10n.chooseLanguageTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.blackColor,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                l10n.chooseLanguageSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white60 : Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // List of Locales
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: locales.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = locales[index];
                    final locale = item['locale'] as Locale;
                    final flag = item['flag'] as String;
                    final name = item['name'] as String;
                    final nativeName = item['nativeName'] as String;
                    final isSelected = _selectedLocale.languageCode == locale.languageCode;

                    return CustomCheckboxTile(
                      title: name,
                      subtitle: nativeName,
                      isSelected: isSelected,
                      onTap: () => _onSelectLocale(locale),
                      leading: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          flag,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Button
              CustomButon(
                text: l10n.continueText,
                height: 54,
                borderRadius: 27,
                onPressed: _onContinue,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
