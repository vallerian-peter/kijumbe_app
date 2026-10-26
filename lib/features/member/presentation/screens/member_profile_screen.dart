import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/profile/profile_hero_header.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/profile/profile_info_card.dart';
import 'package:kijumbe_app/features/member/member.dart';

/// Full-featured Profile Screen for a Member, matching KijumbeProfileScreen layout.
/// Displays editable information cards (Names, Phone, Gender, DOB, Address, Location).
/// Does not show NIDA since Members don't require NIDA registration.
class MemberProfileScreen extends StatefulWidget {
  final MemberProfileData? profileData;

  const MemberProfileScreen({super.key, this.profileData});

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  late String _firstName;
  late String _lastName;
  late String _phone;
  late String _gender;
  late String _dob;
  String _address = 'Mikocheni, Dar es Salaam';
  String _pinnedLocation = 'Mikocheni B, Plot 42';
  final String _joinDate = '26 Sept, 2024';

  @override
  void initState() {
    super.initState();
    _firstName = widget.profileData?.firstName.isNotEmpty == true
        ? widget.profileData!.firstName
        : 'Salma';
    _lastName = widget.profileData?.lastName.isNotEmpty == true
        ? widget.profileData!.lastName
        : 'Rashid';
    _phone = widget.profileData?.displayPhone.isNotEmpty == true
        ? widget.profileData!.displayPhone
        : '+255 712 345 678';
    _gender = widget.profileData?.gender ?? 'Female';
    _dob = widget.profileData?.dob != null
        ? DateFormat('dd MMM, yyyy').format(widget.profileData!.dob!)
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
          labelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: isDark ? Colors.white60 : Colors.grey.shade600,
          ),
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
            borderSide: BorderSide(
              color: isDark ? Colors.white12 : Colors.black12,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.white12 : Colors.black12,
            ),
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
          CustomToast.showSuccess(
            context,
            l10n?.fieldUpdatedSuccess(fieldName) ?? '$fieldName updated',
          );
        }
      },
    );
  }

  void _showGenderEditDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n?.gender ?? 'Gender',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.male_rounded,
                      color: AppColors.appPrimaryColor),
                  title: Text(l10n?.male ?? 'Male'),
                  trailing: _gender == 'Male'
                      ? const Icon(Icons.check, color: AppColors.appPrimaryColor)
                      : null,
                  onTap: () {
                    setState(() => _gender = 'Male');
                    Navigator.of(ctx).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.female_rounded,
                      color: AppColors.appPrimaryColor),
                  title: Text(l10n?.female ?? 'Female'),
                  trailing: _gender == 'Female'
                      ? const Icon(Icons.check, color: AppColors.appPrimaryColor)
                      : null,
                  onTap: () {
                    setState(() => _gender = 'Female');
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDobDatePicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final dobLabel = l10n?.dateOfBirth ?? 'Date of Birth';

    DateTime initialDate = DateTime(1998, 5, 14);
    try {
      initialDate = DateFormat('dd MMM, yyyy').parse(_dob);
    } catch (_) {}

    final pickedDate = await showCustomDatePicker(
      context: context,
      initialDate: initialDate,
      maxDate: DateTime.now(),
      minDate: DateTime(1920, 1, 1),
      title: dobLabel,
      confirmText: l10n?.save ?? 'Save',
      cancelText: l10n?.cancel ?? 'Cancel',
    );

    if (!context.mounted || pickedDate == null) return;
    final formatted = DateFormat('dd MMM, yyyy').format(pickedDate);
    setState(() => _dob = formatted);
    CustomToast.showSuccess(
      context,
      l10n?.fieldUpdatedSuccess(dobLabel) ?? '$dobLabel updated successfully',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Clean Details Top Bar ─────────────────────────────────────────
          SliverAppBar(
            pinned: false,
            snap: true,
            floating: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor:
                isDark ? AppColors.darkGreyColor : AppColors.appGreyWhite,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: CustomBackButton(
                iconColor: isDark ? Colors.white : AppColors.blackColor,
                bgColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            title: Text(
              l10n?.profile ?? 'Profile',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.blackColor,
                letterSpacing: -0.3,
              ),
            ),
            centerTitle: true,
          ),

          // ── Body ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header Card with Avatar, Name, and Role Badge
                  ProfileHeaderCard(
                    name: _fullName,
                    roleBadge: '👤 ${l10n?.memberRegistration ?? 'Member'}',
                    isDark: isDark,
                  ),

                  const SizedBox(height: 22),

                  // Personal info section
                  ProfileSectionLabel(
                    label: l10n?.personalInformation ?? 'Personal Information',
                  ),

                  const SizedBox(height: 10),

                  ProfileInfoCard(
                    items: [
                      ProfileInfoItem(
                        icon: Iconsax.user_outline,
                        label: l10n?.fullName ?? 'Full Name',
                        value: _fullName,
                        iconColor: isDark
                            ? AppColors.darkModePrimaryColor
                            : AppColors.primaryColor,
                        onEdit: () => _showEditDialog(
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
                        ),
                      ),
                      ProfileInfoItem(
                        icon: Iconsax.call_outline,
                        label: l10n?.phoneNumber ?? 'Phone Number',
                        value: _phone,
                        iconColor: const Color(0xFF845EC2),
                        onEdit: () => _showEditDialog(
                          context: context,
                          fieldName: l10n?.phoneNumber ?? 'Phone Number',
                          currentValue: _phone,
                          keyboardType: TextInputType.phone,
                          onSaved: (val) => setState(() => _phone = val),
                        ),
                      ),
                      ProfileInfoItem(
                        icon: Icons.people_outline_rounded,
                        label: l10n?.gender ?? 'Gender',
                        value: _gender == 'Male'
                            ? (l10n?.male ?? 'Male')
                            : (_gender == 'Female'
                                ? (l10n?.female ?? 'Female')
                                : _gender),
                        iconColor: const Color(0xFF4ECDC4),
                        onEdit: () => _showGenderEditDialog(context),
                      ),
                      ProfileInfoItem(
                        icon: Icons.cake_outlined,
                        label: l10n?.dateOfBirth ?? 'Date of Birth',
                        value: _dob,
                        iconColor: const Color(0xFFFF9671),
                        onEdit: () => _showDobDatePicker(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Location section
                  ProfileSectionLabel(
                    label: l10n?.location ?? 'Location',
                  ),
                  const SizedBox(height: 10),
                  ProfileInfoCard(
                    items: [
                      ProfileInfoItem(
                        icon: Icons.location_on_outlined,
                        label: l10n?.address ?? 'Address',
                        value: _address,
                        iconColor: const Color(0xFFFF6B6B),
                        onEdit: () => _showEditDialog(
                          context: context,
                          fieldName: l10n?.address ?? 'Address',
                          currentValue: _address,
                          onSaved: (val) => setState(() => _address = val),
                        ),
                      ),
                      ProfileInfoItem(
                        icon: Icons.map_outlined,
                        label: l10n?.pinnedLocation ?? 'Pinned Location',
                        value: _pinnedLocation,
                        iconColor: const Color(0xFF00C9A7),
                        onEdit: () => _showEditDialog(
                          context: context,
                          fieldName: l10n?.pinnedLocation ?? 'Pinned Location',
                          currentValue: _pinnedLocation,
                          onSaved: (val) => setState(() => _pinnedLocation = val),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Membership section
                  ProfileSectionLabel(
                    label: l10n?.membershipDetails ?? 'Membership Details',
                  ),
                  const SizedBox(height: 10),
                  ProfileInfoCard(
                    items: [
                      ProfileInfoItem(
                        icon: Iconsax.calendar_tick_outline,
                        label: l10n?.memberSince ?? 'Member Since',
                        value: _joinDate,
                        iconColor: const Color(0xFF2C73D2),
                      ),
                      ProfileInfoItem(
                        icon: Iconsax.shield_tick_outline,
                        label: l10n?.verificationStatus ?? 'Status',
                        value: l10n?.activeStatus ?? 'Active',
                        iconColor: AppColors.greenColor,
                      ),
                    ],
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
