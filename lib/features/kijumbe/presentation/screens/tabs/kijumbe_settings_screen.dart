import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/settings/settings_card_group.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/settings/settings_profile_card.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/settings/settings_tile_item.dart';
import 'package:kijumbe_app/helpers/biometric_auth_helper.dart';

class KijumbeSettingsScreen extends StatefulWidget {
  const KijumbeSettingsScreen({super.key});

  @override
  State<KijumbeSettingsScreen> createState() => _KijumbeSettingsScreenState();
}

class _KijumbeSettingsScreenState extends State<KijumbeSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _biometricEnabled = AppStorageManager.instance.isBiometricAuthEnabled();
  }

  Future<void> _handleBiometricToggle(bool enable) async {
    final isSw = Localizations.localeOf(context).languageCode == 'sw';

    if (enable) {
      // 1. Check if biometric hardware and enrollment is present on the phone
      final isAvailable = await BiometricAuthHelper.isBiometricAvailable();
      if (!isAvailable) {
        if (mounted) {
          setState(() => _biometricEnabled = false);
          CustomToast.showError(
            context,
            isSw
                ? 'Utambuzi wa alama za vidole au uso haupatikani kwenye kifaa hiki'
                : 'Biometric authentication is not supported or not set up on this device',
          );
        }
        return;
      }

      // 2. Present biometric auth popup scanning
      final authenticated = await BiometricAuthHelper.authenticate(
        reason: isSw
            ? 'Thibitisha alama ya kidole kuwezesha Kuingia kwa Biometria'
            : 'Scan your fingerprint or face to enable Biometric Login',
      );

      if (!mounted) return;

      if (authenticated) {
        setState(() => _biometricEnabled = true);
        await AppStorageManager.instance.setBiometricAuthEnabled(true);
        if (!mounted) return;
        CustomToast.showSuccess(
          context,
          isSw
              ? 'Kuingia kwa alama ya kidole kumewezeshwa kikamilifu'
              : 'Biometric Login enabled successfully',
        );
      } else {
        setState(() => _biometricEnabled = false);
        await AppStorageManager.instance.setBiometricAuthEnabled(false);
        if (!mounted) return;
        CustomToast.showError(
          context,
          isSw
              ? 'Uthibitishaji wa alama ya kidole umeshindikana au umesitishwa'
              : 'Biometric authentication was cancelled or failed',
        );
      }
    } else {
      setState(() => _biometricEnabled = false);
      await AppStorageManager.instance.setBiometricAuthEnabled(false);
      if (!mounted) return;
      CustomToast.showInfo(
        context,
        isSw
            ? 'Kuingia kwa alama ya kidole kumezimwa'
            : 'Biometric Login disabled',
      );
    }
  }

  void _showLogoutDialog(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF3D3D3D) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n?.logout ?? 'Logout',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.blackColor,
          ),
        ),
        content: Text(
          l10n?.logoutConfirmationMsg ??
              'Are you sure you want to log out from Kijumbe?',
          style: TextStyle(
            fontFamily: 'Inter',
            color: isDark ? Colors.white70 : Colors.grey.shade600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l10n?.cancel ?? 'Cancel',
              style: TextStyle(
                fontFamily: 'Inter',
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              l10n?.logout ?? 'Logout',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                color: Color(0xFFFF4757),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: isDark
            ? Colors.white54
            : AppColors.darkGreyColor.withValues(alpha: 0.55),
        letterSpacing: 0.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── AppBar ─────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            backgroundColor:
                isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Text(
              l10n?.settings ?? 'Settings',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.blackColor,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Profile card ──────────────────────────────────────────
                  SettingsProfileCard(
                    name: 'Vallerian Mchau',
                    phone: '+255 712 345 678',
                    role: 'Kijumbe',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 28),

                  // ── Preferences section ─────────────────────────────────────
                  _buildSectionLabel(
                      l10n?.preferences ?? 'Preferences', isDark),
                  const SizedBox(height: 10),
                  SettingsCardGroup(
                    isDark: isDark,
                    tiles: [
                      SettingsTileItem(
                        icon: Icons.notifications_outlined,
                        iconColor: const Color(0xFFFF9671),
                        title: l10n?.notifications ?? 'Notifications',
                        subtitle: _notificationsEnabled
                            ? (l10n?.enabled ?? 'Enabled')
                            : (l10n?.disabled ?? 'Disabled'),
                        isDark: isDark,
                        trailing: Switch.adaptive(
                          value: _notificationsEnabled,
                          activeTrackColor: isDark ? AppColors.darkModePrimaryColor.withValues(alpha: 0.5) : null,
                          activeThumbColor: isDark ? Colors.white : AppColors.primaryColor,
                          onChanged: (v) =>
                              setState(() => _notificationsEnabled = v),
                        ),
                      ),
                      SettingsTileItem(
                        icon: isDark
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        iconColor: const Color(0xFFFFBE0B),
                        title: l10n?.darkMode ?? 'Dark Mode',
                        subtitle: isDark
                            ? (l10n?.enabled ?? 'Enabled')
                            : (l10n?.disabled ?? 'Disabled'),
                        isDark: isDark,
                        trailing: Switch.adaptive(
                          value: isDark,
                          activeTrackColor: isDark ? AppColors.darkModePrimaryColor.withValues(alpha: 0.5) : null,
                          activeThumbColor: isDark ? Colors.white : AppColors.primaryColor,
                          onChanged: (v) {
                            ThemeManager.instance.setThemeMode(
                              v ? ThemeMode.dark : ThemeMode.light,
                            );
                          },
                        ),
                      ),
                      SettingsTileItem(
                        icon: Iconsax.language_square_outline,
                        iconColor: const Color(0xFF4ECDC4),
                        title: l10n?.language ?? 'Language',
                        subtitle: Localizations.localeOf(context).languageCode == 'sw'
                            ? 'Kiswahili (SW)'
                            : 'English (EN)',
                        isDark: isDark,
                        onTap: () => LanguageSelectionBottomSheet.show(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Security section ────────────────────────────────────────
                  _buildSectionLabel(l10n?.security ?? 'Security', isDark),
                  const SizedBox(height: 10),
                  SettingsCardGroup(
                    isDark: isDark,
                    tiles: [
                      SettingsTileItem(
                        icon: Icons.fingerprint_rounded,
                        iconColor: const Color(0xFF00C9A7),
                        title: l10n?.biometricLogin ?? 'Biometric Login',
                        subtitle: _biometricEnabled
                            ? (l10n?.enabled ?? 'Enabled')
                            : (l10n?.disabled ?? 'Disabled'),
                        isDark: isDark,
                        trailing: Switch.adaptive(
                          value: _biometricEnabled,
                          activeTrackColor: isDark ? AppColors.darkModePrimaryColor.withValues(alpha: 0.5) : null,
                          activeThumbColor: isDark ? Colors.white : AppColors.primaryColor,
                          onChanged: _handleBiometricToggle,
                        ),
                      ),
                      SettingsTileItem(
                        icon: Icons.lock_outline_rounded,
                        iconColor: const Color(0xFF845EC2),
                        title: l10n?.resetPassword ?? 'Change PIN / Password',
                        subtitle: l10n?.changePasswordSubtitle ??
                            'Update your security credentials',
                        isDark: isDark,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Legal & Support section ─────────────────────────────────
                  _buildSectionLabel(l10n?.support ?? 'Support & Legal', isDark),
                  const SizedBox(height: 10),
                  SettingsCardGroup(
                    isDark: isDark,
                    tiles: [
                      SettingsTileItem(
                        icon: Icons.help_outline_rounded,
                        iconColor: const Color(0xFF4D8076),
                        title: l10n?.helpCenter ?? 'Help Center & FAQ',
                        isDark: isDark,
                        onTap: () {},
                      ),
                      SettingsTileItem(
                        icon: Icons.description_outlined,
                        iconColor: const Color(0xFF0081CF),
                        title: l10n?.termsOfService ?? 'Terms of Service',
                        isDark: isDark,
                        onTap: () {},
                      ),
                      SettingsTileItem(
                        icon: Icons.privacy_tip_outlined,
                        iconColor: const Color(0xFF2C73D2),
                        title: l10n?.privacyPolicy ?? 'Privacy Policy',
                        isDark: isDark,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── Logout button ───────────────────────────────────────────
                  GestureDetector(
                    onTap: () => _showLogoutDialog(context, isDark),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4757).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFF4757).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout_rounded,
                              color: Color(0xFFFF4757), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            l10n?.logout ?? 'Logout',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF4757),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // App version
                  Center(
                    child: Text(
                      '${l10n?.appVersion ?? 'App Version'} 1.0.0 (Build 2026)',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: isDark ? Colors.white30 : Colors.grey.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
