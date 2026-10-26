import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kijumbe_app/core/components/custom_alert_dialog.dart';
import 'package:kijumbe_app/core/utils/colors.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/profile/profile_hero_header.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/profile/profile_info_card.dart';
import 'package:kijumbe_app/features/member/member.dart';
import 'package:kijumbe_app/l10n/app_localizations.dart';

/// Profile tab for Member dashboard.
/// Displays member's personal information (Names, Phone, DOB, Gender).
/// No NIDA details are shown since Member registration does not require NIDA.
class MemberProfileTab extends StatefulWidget {
  final MemberProfileData? initialData;

  const MemberProfileTab({super.key, this.initialData});

  @override
  State<MemberProfileTab> createState() => _MemberProfileTabState();
}

class _MemberProfileTabState extends State<MemberProfileTab> {
  late String _firstName;
  late String _lastName;
  late String _phone;
  late String _gender;
  late String _dob;
  final String _joinDate = '26 Sept, 2024';

  @override
  void initState() {
    super.initState();
    _firstName = widget.initialData?.firstName.isNotEmpty == true
        ? widget.initialData!.firstName
        : 'Salma';
    _lastName = widget.initialData?.lastName.isNotEmpty == true
        ? widget.initialData!.lastName
        : 'Rashid';
    _phone = widget.initialData?.displayPhone.isNotEmpty == true
        ? widget.initialData!.displayPhone
        : '+255 712 345 678';
    _gender = widget.initialData?.gender ?? 'Female';
    _dob = widget.initialData?.dob != null
        ? '${widget.initialData!.dob!.day}/${widget.initialData!.dob!.month}/${widget.initialData!.dob!.year}'
        : '14 May, 1998';
  }

  String get _fullName => '$_firstName $_lastName';

  void _showEditDialog({
    required BuildContext context,
    required String fieldName,
    required String currentValue,
    required ValueChanged<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: currentValue);

    CustomActionDialog.show(
      context,
      icon: Iconsax.edit_2_outline,
      iconColor: AppColors.appPrimaryColor,
      title: l10n?.editField(fieldName) ?? 'Edit $fieldName',
      subtitle: l10n?.updateFieldSubtitle(fieldName) ??
          'Update your $fieldName information below',
      content: TextField(
        controller: controller,
        keyboardType: keyboardType,
        autofocus: true,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.blackColor,
        ),
        decoration: InputDecoration(
          labelText: fieldName,
          filled: true,
          fillColor: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFF6F8FA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.appPrimaryColor,
              width: 1.5,
            ),
          ),
        ),
      ),
      primaryButtonText: l10n?.update ?? 'Update',
      secondaryButtonText: l10n?.cancel ?? 'Cancel',
      onPrimaryPressed: () {
        final text = controller.text.trim();
        if (text.isNotEmpty) {
          onSaved(text);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n?.fieldUpdatedSuccess(fieldName) ??
                    '$fieldName updated successfully',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
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
          // ── Hero App Bar ──────────────────────────────────────────────────
          ProfileHeroSliverAppBar(
            name: _fullName,
            roleBadge: '👤 ${l10n?.memberRegistration ?? 'Member'}',
            onBackPressed: () {},
            onEditPressed: () {
              _showEditDialog(
                context: context,
                fieldName: l10n?.fullName ?? 'Full Name',
                currentValue: _fullName,
                onSaved: (val) {
                  final parts = val.split(' ');
                  setState(() {
                    _firstName = parts.first;
                    _lastName =
                        parts.length > 1 ? parts.sublist(1).join(' ') : '';
                  });
                },
              );
            },
          ),

          // ── Personal Information Section ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
              child: ProfileSectionLabel(
                label: (l10n?.personalInformation ?? 'PERSONAL INFORMATION')
                    .toUpperCase(),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ProfileInfoCard(
                items: [
                  ProfileInfoItem(
                    icon: Icons.person_outline_rounded,
                    iconColor: AppColors.appPrimaryColor,
                    label: l10n?.fullName ?? 'Full Name',
                    value: _fullName,
                    onEdit: () {
                      _showEditDialog(
                        context: context,
                        fieldName: l10n?.fullName ?? 'Full Name',
                        currentValue: _fullName,
                        onSaved: (val) {
                          final parts = val.split(' ');
                          setState(() {
                            _firstName = parts.first;
                            _lastName = parts.length > 1
                                ? parts.sublist(1).join(' ')
                                : '';
                          });
                        },
                      );
                    },
                  ),
                  ProfileInfoItem(
                    icon: Icons.phone_outlined,
                    iconColor: const Color(0xFF00B4D8),
                    label: l10n?.phoneNumber ?? 'Phone Number',
                    value: _phone,
                    onEdit: () {
                      _showEditDialog(
                        context: context,
                        fieldName: l10n?.phoneNumber ?? 'Phone Number',
                        currentValue: _phone,
                        keyboardType: TextInputType.phone,
                        onSaved: (val) => setState(() => _phone = val),
                      );
                    },
                  ),
                  ProfileInfoItem(
                    icon: Icons.cake_outlined,
                    iconColor: const Color(0xFFFFBE0B),
                    label: l10n?.dateOfBirth ?? 'Date of Birth',
                    value: _dob,
                  ),
                  ProfileInfoItem(
                    icon: Icons.people_outline_rounded,
                    iconColor: const Color(0xFF4ECDC4),
                    label: l10n?.gender ?? 'Gender',
                    value: _gender,
                  ),
                  ProfileInfoItem(
                    icon: Icons.calendar_today_outlined,
                    iconColor: const Color(0xFF6C5CE7),
                    label: l10n?.memberSince ?? 'Member Since',
                    value: _joinDate,
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 36),
          ),
        ],
      ),
    );
  }
}
