import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:kijumbe_app/core/core.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/profile/profile_hero_header.dart';
import 'package:kijumbe_app/features/kijumbe/presentation/widgets/profile/profile_info_card.dart';

class KijumbeProfileScreen extends StatefulWidget {
  const KijumbeProfileScreen({super.key});

  @override
  State<KijumbeProfileScreen> createState() => _KijumbeProfileScreenState();
}

class _KijumbeProfileScreenState extends State<KijumbeProfileScreen> {
  // ── Profile data ─────────────────────────────────────────────────────────
  String _name = 'Vallerian Mchau';
  String _phone = '+255 712 345 678';
  String _gender = 'Male';
  String _dob = '12 Jan, 1990';
  String _address = 'Dar es Salaam, Tanzania';
  String _pinnedLocation = 'Ubungo, Dar es Salaam';
  final String _nida = '19900115-15001-10001-23';
  final String _joinDate = '12 Sept, 2024';

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
      iconColor: AppColors.primaryColor,
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
              color: AppColors.primaryColor,
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

  void _showPhoneEditDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final phoneLabel = l10n?.phoneNumber ?? 'Phone Number';

    // Extract digits (e.g. "+255 712 345 678" -> "712345678")
    String rawDigits = _phone.replaceAll(RegExp(r'\D'), '');
    if (rawDigits.startsWith('255') && rawDigits.length > 3) {
      rawDigits = rawDigits.substring(3);
    }
    final phoneController = TextEditingController(text: rawDigits);
    String completeNumber = _phone;

    CustomActionDialog.show(
      context,
      icon: Iconsax.call_outline,
      iconColor: const Color(0xFF845EC2),
      title: l10n?.editField(phoneLabel) ?? 'Edit $phoneLabel',
      subtitle: l10n?.updateFieldSubtitle(phoneLabel) ??
          'Update your $phoneLabel information below',
      content: CustomPhoneNumberField(
        controller: phoneController,
        isDark: isDark,
        autofocus: true,
        onChanged: (phone) {
          completeNumber = phone.completeNumber;
        },
      ),
      primaryButtonText: l10n?.update ?? 'Update',
      secondaryButtonText: l10n?.cancel ?? 'Cancel',
      onPrimaryPressed: () {
        final digits = phoneController.text.replaceAll(RegExp(r'\D'), '');
        if (digits.isNotEmpty) {
          String formatted;
          if (digits.length >= 9) {
            final p1 = digits.substring(0, 3);
            final p2 = digits.substring(3, 6);
            final p3 = digits.substring(6);
            formatted = '+255 $p1 $p2 $p3';
          } else {
            formatted = completeNumber.isNotEmpty ? completeNumber : '+255 $digits';
          }
          setState(() => _phone = formatted);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n?.fieldUpdatedSuccess(phoneLabel) ??
                    '$phoneLabel updated successfully',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  void _showGenderEditDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final genderLabel = l10n?.gender ?? 'Gender';
    String selectedGender = _gender;

    CustomActionDialog.show(
      context,
      icon: Icons.people_outline_rounded,
      iconColor: const Color(0xFF4ECDC4),
      title: l10n?.editField(genderLabel) ?? 'Edit $genderLabel',
      subtitle: l10n?.updateFieldSubtitle(genderLabel) ??
          'Select your $genderLabel below',
      content: StatefulBuilder(
        builder: (ctx, setDialogState) {
          return DropdownButtonFormField<String>(
            initialValue: selectedGender,
            dropdownColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.blackColor,
            ),
            decoration: InputDecoration(
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
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isDark ? Colors.white70 : AppColors.blackColor,
            ),
            items: [
              DropdownMenuItem(
                value: 'Male',
                child: Row(
                  children: [
                    const Icon(
                      Icons.male_rounded,
                      size: 20,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(l10n?.male ?? 'Male'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'Female',
                child: Row(
                  children: [
                    const Icon(
                      Icons.female_rounded,
                      size: 20,
                      color: Color(0xFFFF6B6B),
                    ),
                    const SizedBox(width: 10),
                    Text(l10n?.female ?? 'Female'),
                  ],
                ),
              ),
            ],
            onChanged: (val) {
              if (val != null) {
                setDialogState(() => selectedGender = val);
              }
            },
          );
        },
      ),
      primaryButtonText: l10n?.update ?? 'Update',
      secondaryButtonText: l10n?.cancel ?? 'Cancel',
      onPrimaryPressed: () {
        setState(() => _gender = selectedGender);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n?.fieldUpdatedSuccess(genderLabel) ??
                  '$genderLabel updated successfully',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  Future<void> _showDobDatePicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final dobLabel = l10n?.dateOfBirth ?? 'Date of Birth';
    DateTime initialDate;
    try {
      initialDate = DateFormat('dd MMM, yyyy').parse(_dob);
    } catch (_) {
      try {
        initialDate = DateFormat('dd MMM yyyy').parse(_dob);
      } catch (_) {
        initialDate = DateTime(1990, 1, 12);
      }
    }

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n?.fieldUpdatedSuccess(dobLabel) ??
              '$dobLabel updated successfully',
        ),
        behavior: SnackBarBehavior.floating,
      ),
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
          // ── Clean Details Top Bar (Matches Group Details Screen) ─────────
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
                    name: _name,
                    roleBadge: '⭐ Kijumbe',
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
                        value: _name,
                        iconColor: isDark
                            ? AppColors.darkModePrimaryColor
                            : AppColors.primaryColor,
                        onEdit: () => _showEditDialog(
                          context: context,
                          fieldName: l10n?.fullName ?? 'Full Name',
                          currentValue: _name,
                          onSaved: (val) => setState(() => _name = val),
                        ),
                      ),
                      ProfileInfoItem(
                        icon: Iconsax.call_outline,
                        label: l10n?.phoneNumber ?? 'Phone Number',
                        value: _phone,
                        iconColor: const Color(0xFF845EC2),
                        onEdit: () => _showPhoneEditDialog(context),
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

                  // Identification section (System/Official records)
                  ProfileSectionLabel(
                    label: l10n?.identification ?? 'Identification',
                  ),
                  const SizedBox(height: 10),
                  ProfileInfoCard(
                    items: [
                      ProfileInfoItem(
                        icon: Iconsax.card_outline,
                        label: l10n?.nidaNumber ?? 'NIDA Number',
                        value: _nida,
                        iconColor: const Color(0xFF845EC2),
                      ),
                      ProfileInfoItem(
                        icon: Icons.calendar_today_outlined,
                        label: l10n?.memberSince ?? 'Member Since',
                        value: _joinDate,
                        iconColor: AppColors.primaryColor,
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

