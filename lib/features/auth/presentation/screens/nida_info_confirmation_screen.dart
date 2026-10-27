import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../models/profile_registration_data.dart';
import 'registration_success_screen.dart';

/// Screen displayed after NIDA security verification to review and confirm
/// official personal details retrieved from the National Identification Authority.
/// Exactly matches the Banking App implementation with a clean user image card
/// and structured information rows without extraneous badges.
class NidaInfoConfirmationScreen extends StatelessWidget {
  final ProfileRegistrationData profileData;
  final VoidCallback? onConfirmed;

  const NidaInfoConfirmationScreen({
    super.key,
    required this.profileData,
    this.onConfirmed,
  });

  String _formatNin(String rawNin) {
    final clean = rawNin.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 20) {
      return '${clean.substring(0, 8)}-${clean.substring(8, 13)}-${clean.substring(13, 18)}-${clean.substring(18, 20)}';
    }
    return rawNin.isNotEmpty ? rawNin : '19950824-11105-00001-27';
  }

  String _formatDob(DateTime? date) {
    if (date == null) return '12/09/1991';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  void _handleProceed(BuildContext context) {
    if (onConfirmed != null) {
      onConfirmed!();
      return;
    }

    final l10n = context.l10n;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationSuccessScreen(
          title: l10n.congratulationsTitle,
          description:
              '${l10n.welcome}, ${profileData.firstName}! ${l10n.congratulationsSubtitle}',
          firstName: profileData.firstName,
          phone: profileData.displayPhone,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    final rows = [
      (
        l10n.firstName,
        profileData.firstName.isNotEmpty
            ? profileData.firstName.toUpperCase()
            : 'EMMANUEL',
      ),
      if (profileData.middleName != null &&
          profileData.middleName!.trim().isNotEmpty)
        (
          l10n.middleNameHint,
          profileData.middleName!.toUpperCase(),
        ),
      (
        l10n.lastName,
        profileData.lastName.isNotEmpty
            ? profileData.lastName.toUpperCase()
            : 'SUYA',
      ),
      (
        l10n.gender,
        (profileData.gender.toLowerCase() == 'male'
                ? l10n.male
                : profileData.gender.toLowerCase() == 'female'
                    ? l10n.female
                    : profileData.gender)
            .toUpperCase(),
      ),
      (
        l10n.dateOfBirth,
        _formatDob(profileData.dob),
      ),
      (
        l10n.city,
        profileData.city.isNotEmpty
            ? profileData.city.toUpperCase()
            : 'DAR ES SALAAM (UBUNGO)',
      ),
      (
        l10n.ninLabel,
        _formatNin(profileData.nin),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CustomBackButton(
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          l10n.nidaInfoConfirmationTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.blackColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Column(
                  children: [
                    // Profile Box copied from Banking App
                    CustomCard(
                      width: 250,
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            AppAssets.userAvatar,
                            fit: BoxFit.cover,
                            width: 260,
                            height: 200,
                            errorBuilder: (_, __, ___) => Container(
                              width: 260,
                              height: 200,
                              color: isDark ? Colors.white10 : Colors.black12,
                              child: const Icon(
                                Icons.person_rounded,
                                size: 72,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Your Information Card
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.yourInformation,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : AppColors.blackColor,
                            ),
                          ),

                          const SizedBox(height: 16),

                          ...rows.asMap().entries.map((entry) {
                            final isLast = entry.key == rows.length - 1;
                            final row = entry.value;

                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              decoration: BoxDecoration(
                                border: isLast
                                    ? null
                                    : Border(
                                        bottom: BorderSide(
                                          color: isDark
                                              ? Colors.white10
                                              : Colors.black.withValues(alpha: 0.06),
                                        ),
                                      ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      row.$1,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? Colors.white60 : Colors.black54,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      row.$2,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.blueSkyStrong
                                            : AppColors.appPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Actions Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27),
                        ),
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.grey[400]!,
                        ),
                      ),
                      child: Text(
                        l10n.cancel,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: CustomButon(
                      text: l10n.proceed,
                      height: 54,
                      borderRadius: 27,
                      gradient: AppColors.primaryBlueGradient,
                      onPressed: () => _handleProceed(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
