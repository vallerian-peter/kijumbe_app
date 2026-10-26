import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../auth.dart';
import '../../../kijumbe/kijumbe.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String? initialPhone;

  const CompleteProfileScreen({
    super.key,
    this.initialPhone,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  int _currentStep = 1;
  final int _totalSteps = 4;

  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  final ProfileRegistrationData _data = ProfileRegistrationData();

  // Step 1 Controllers (Names)
  late final TextEditingController _firstNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _lastNameController;

  // Step 3 Controllers (Address)
  late final TextEditingController _countryController;
  late final TextEditingController _cityController;
  late final TextEditingController _streetController;

  @override
  void initState() {
    super.initState();
    if (widget.initialPhone != null && widget.initialPhone!.isNotEmpty) {
      _data.phone = widget.initialPhone!;
      _data.fullPhone = widget.initialPhone!;
      _data.isPhoneVerified = true;
    }

    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();

    _countryController = TextEditingController(text: 'Tanzania');
    _cityController = TextEditingController(text: 'Dar es Salaam');
    _streetController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  void _onNextStep() {
    if (_currentStep == 1) {
      // Step 1: Legal Names
      if (!(_formKeyStep1.currentState?.validate() ?? false)) return;
      _data.firstName = _firstNameController.text.trim();
      _data.middleName = _middleNameController.text.trim();
      _data.lastName = _lastNameController.text.trim();
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      // Step 2: DOB & Gender
      if (_data.dob == null) {
        CustomToast.showWarning(context, context.l10n.dobRequired);
        return;
      }
      if (!DateValidationUtils.is18OrOlder(_data.dob!)) {
        CustomToast.showDanger(context, context.l10n.underAgeError);
        return;
      }
      setState(() => _currentStep = 3);
    } else if (_currentStep == 3) {
      // Step 3: Address & Location Pinpoint
      if (!(_formKeyStep3.currentState?.validate() ?? false)) return;
      _data.country = _countryController.text.trim();
      _data.city = _cityController.text.trim();
      _data.streetAddress = _streetController.text.trim();
      setState(() => _currentStep = 4);
    } else if (_currentStep == 4) {
      // Step 4: NIDA Identity Verification
      if (!_data.isNidaVerified) {
        CustomToast.showWarning(
          context,
          'Please complete NIDA verification to continue',
        );
        return;
      }
      setState(() => _currentStep = 5);
    } else if (_currentStep == 5) {
      // Step 5: Mobile Phone Number
      final rawPhone = _data.phone.replaceAll(RegExp(r'\D'), '');
      if (rawPhone.length < 8) {
        CustomToast.showWarning(
          context,
          'Please enter a valid phone number',
        );
        return;
      }
      CustomToast.showSuccess(
        context,
        'Verification code sent to ${_data.displayPhone}',
      );
      setState(() => _currentStep = 6);
    } else if (_currentStep == 6) {
      // Step 6: Phone OTP Verification - only process match when user clicks the button
      if (_data.otpCode.length != 6) {
        CustomToast.showWarning(
          context,
          context.l10n.otpRequired,
        );
        return;
      }
      _data.isPhoneVerified = true;
      ConfirmationAlertDialog.show(
        context,
        type: AlertType.success,
        title: context.l10n.profileCompletedTitle,
        message: context.l10n.profileCompletedMsg,
        confirmText: context.l10n.continueText,
        showCancel: false,
        onConfirm: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => RegistrationSuccessScreen(
                firstName: _data.firstName,
                phone: _data.displayPhone,
                onProceed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const KijumbeDashboard(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          );
        },
      );
    }
  }

  void _onPreviousStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _openLocationPicker() async {
    final result = await LocationPinpointSheet.show(
      context,
      initialLat: _data.latitude,
      initialLng: _data.longitude,
      initialAddress: _data.pinpointAddress ?? _streetController.text,
    );

    if (result != null) {
      setState(() {
        _data.latitude = result.latitude;
        _data.longitude = result.longitude;
        _data.pinpointAddress = result.address;
        if (_streetController.text.isEmpty) {
          _streetController.text = result.address;
        }
      });
      if (!mounted) return;
      CustomToast.showSuccess(context, 'Location pinpointed successfully!');
    }
  }


  bool _isContinueButtonEnabled() {
    if (_currentStep == 4) {
      return _data.isNidaVerified;
    }
    if (_currentStep == 6) {
      return _data.otpCode.length == 6;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CustomBackButton(
            onTap: _onPreviousStep,
          ),
        ),
        title: Text(
          l10n.completeProfileTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: isDark ? Colors.white : AppColors.blackColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horizontal Stepper Bar (Step X of 6)
                    HorizontalStepper(
                      currentStep: _currentStep,
                      totalSteps: _totalSteps,
                      stepLabel: l10n.step,
                      height: 5.0,
                      spacing: 6.0,
                      borderRadius: 4.0,
                    ),
                    const SizedBox(height: 24),

                    // Stretched Micro-Step Views
                    if (_currentStep == 1) _buildStep1Names(theme, l10n, isDark),
                    if (_currentStep == 2) _buildStep2DobGender(theme, l10n, isDark),
                    if (_currentStep == 3) _buildStep3Address(theme, l10n, isDark),
                    if (_currentStep == 4) _buildStep4Nida(theme, l10n, isDark),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Floating Bottom Action Bar
            _buildBottomActionBar(theme, l10n, isDark),
          ],
        ),
      ),
    );
  }

  // ================= STEP 1: LEGAL NAMES =================
  Widget _buildStep1Names(ThemeData theme, dynamic l10n, bool isDark) {
    return Form(
      key: _formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            icon: Icons.person_outline_rounded,
            title: l10n.tellUsAboutYourself,
            subtitle: 'Enter your legal names matching your official NIDA ID card.',
            isDark: isDark,
          ),
          const SizedBox(height: 24),

          // First Name Field
          CustomTextField(
            controller: _firstNameController,
            label: l10n.firstName,
            hintText: l10n.firstNameHint,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.badge_outlined, size: 20),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.firstNameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Middle Name Field (Optional)
          CustomTextField(
            controller: _middleNameController,
            label: l10n.middleNameOptional,
            hintText: l10n.middleNameHint,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.badge_outlined, size: 20),
          ),
          const SizedBox(height: 16),

          // Last Name Field
          CustomTextField(
            controller: _lastNameController,
            label: l10n.lastName,
            hintText: l10n.lastNameHint,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.badge_outlined, size: 20),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.lastNameRequired;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // ================= STEP 2: DOB & GENDER =================
  Widget _buildStep2DobGender(ThemeData theme, dynamic l10n, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          icon: Icons.cake_outlined,
          title: 'When were you born?',
          subtitle: 'Select your birth date and gender. You must be 18+ to register.',
          isDark: isDark,
        ),
        const SizedBox(height: 24),

        // Unified Custom Date Picker Field with dual Wheel/Calendar mode
        CustomDatePickerField(
          label: l10n.dateOfBirth,
          hintText: l10n.dateOfBirthHint,
          selectedDate: _data.dob,
          require18Plus: true,
          helperText: l10n.dobAgeRequirement,
          onDateSelected: (date) {
            setState(() {
              _data.dob = date;
            });
          },
        ),
        const SizedBox(height: 24),

        // Gender Selector
        Text(
          l10n.gender,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleSmall?.color,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildGenderChoice(
                label: l10n.male,
                icon: Icons.male_rounded,
                isSelected: _data.gender == 'Male',
                isDark: isDark,
                onTap: () => setState(() => _data.gender = 'Male'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildGenderChoice(
                label: l10n.female,
                icon: Icons.female_rounded,
                isSelected: _data.gender == 'Female',
                isDark: isDark,
                onTap: () => setState(() => _data.gender = 'Female'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= STEP 3: RESIDENTIAL ADDRESS =================
  Widget _buildStep3Address(ThemeData theme, dynamic l10n, bool isDark) {
    final hasPinpoint = _data.latitude != null && _data.longitude != null;

    return Form(
      key: _formKeyStep3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            icon: Icons.home_outlined,
            title: l10n.residentialAddressTitle,
            subtitle: l10n.residentialAddressSubtitle,
            isDark: isDark,
          ),
          const SizedBox(height: 24),

          // Country Field
          CustomTextField(
            controller: _countryController,
            label: l10n.country,
            hintText: l10n.countryHint,
            prefixIcon: const Icon(Icons.public_rounded, size: 20),
          ),
          const SizedBox(height: 16),

          // City / Region Field
          CustomTextField(
            controller: _cityController,
            label: l10n.city,
            hintText: l10n.cityHint,
            prefixIcon: const Icon(Icons.location_city_rounded, size: 20),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.cityRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Street Address Field
          CustomTextField(
            controller: _streetController,
            label: l10n.streetAddress,
            hintText: l10n.streetAddressHint,
            prefixIcon: const Icon(Icons.signpost_outlined, size: 20),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.streetAddressRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 22),

          // Location to Pinpoint Interactive Card
          Text(
            l10n.locationPinpointTitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleSmall?.color,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E232A) : AppColors.appGreyWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasPinpoint
                    ? AppColors.appPrimaryColor
                    : (isDark ? Colors.white12 : Colors.black12),
                width: hasPinpoint ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.appPrimaryColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.map_rounded,
                        color: AppColors.appPrimaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasPinpoint
                                ? l10n.locationSelected
                                : l10n.locationNotSelected,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: hasPinpoint
                                  ? AppColors.appPrimaryColor
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hasPinpoint
                                ? '${_data.pinpointAddress ?? ''}\n(${_data.latitude?.toStringAsFixed(4)}, ${_data.longitude?.toStringAsFixed(4)})'
                                : 'Search or use device GPS to pinpoint your stay location',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white60 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                CustomButton(
                  text: hasPinpoint ? 'Update Pinpoint' : l10n.pinpointLocationBtn,
                  onPressed: _openLocationPicker,
                  height: 44,
                  borderRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= STEP 4: NIDA VERIFICATION =================
  Widget _buildStep4Nida(ThemeData theme, dynamic l10n, bool isDark) {
    return NidaVerificationStep(
      initialNin: _data.nin,
      initialVerified: _data.isNidaVerified,
      onNinChanged: (val) {
        _data.nin = val;
      },
      onVerificationStatusChanged: (isVerified) {
        setState(() {
          _data.isNidaVerified = isVerified;
        });
      },
    );
  }


  // Header banner builder
  Widget _buildStepHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    final iconColor = isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.blackColor,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white60 : Colors.grey[600],
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderChoice({
    required String label,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final activeColor = isDark ? AppColors.darkModePrimaryColor : AppColors.appPrimaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : (isDark ? const Color(0xFF1E232A) : AppColors.appGreyWhite),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? Colors.white12 : Colors.black12),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? activeColor : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? activeColor
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FLOATING BOTTOM BAR =================
  Widget _buildBottomActionBar(ThemeData theme, dynamic l10n, bool isDark) {
    final isLastStep = _currentStep == _totalSteps;
    final isEnabled = _isContinueButtonEnabled();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 1) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _onPreviousStep,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  side: BorderSide(
                    color: isDark ? Colors.white24 : Colors.grey[400]!,
                  ),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            flex: 2,
            child: CustomButton(
              text: isLastStep ? l10n.verifyAndComplete : l10n.continueText,
              height: 52,
              borderRadius: 26,
              gradient: isEnabled ? AppColors.primaryTealGradient : null,
              bgColor: isEnabled ? null : (isDark ? Colors.grey[800] : Colors.grey[300]),
              textColor: isEnabled ? Colors.white : (isDark ? Colors.white38 : Colors.grey[500]),
              onPressed: isEnabled ? _onNextStep : null,
            ),
          ),
        ],
      ),
    );
  }
}
