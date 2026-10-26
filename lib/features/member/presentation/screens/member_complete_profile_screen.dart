import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../auth/auth.dart';
import '../../member.dart';

/// Screen for Member registration profile completion following Kijumbe's stepper structure:
/// - HorizontalStepper (2 steps: Names, then DOB & Gender)
/// - Step 1: Personal Information (First Name, Last Name)
/// - Step 2: Date of Birth (18+ restriction) & Gender selection
/// - Clean, uncluttered AppBar and floating bottom action bar
class MemberCompleteProfileScreen extends StatefulWidget {
  final MemberProfileData profileData;

  const MemberCompleteProfileScreen({
    super.key,
    required this.profileData,
  });

  @override
  State<MemberCompleteProfileScreen> createState() =>
      _MemberCompleteProfileScreenState();
}

class _MemberCompleteProfileScreenState
    extends State<MemberCompleteProfileScreen> {
  int _currentStep = 1;
  final int _totalSteps = 2;

  final _formKeyStep1 = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.profileData.firstName);
    _lastNameController =
        TextEditingController(text: widget.profileData.lastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onNextStep() {
    if (_currentStep == 1) {
      if (!(_formKeyStep1.currentState?.validate() ?? false)) return;
      widget.profileData.firstName = _firstNameController.text.trim();
      widget.profileData.lastName = _lastNameController.text.trim();
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      if (widget.profileData.dob == null) {
        CustomToast.showWarning(context, context.l10n.dobRequired);
        return;
      }
      if (!DateValidationUtils.is18OrOlder(widget.profileData.dob!)) {
        CustomToast.showDanger(context, context.l10n.underAgeError);
        return;
      }
      _onComplete();
    }
  }

  void _onPreviousStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onComplete() {
    widget.profileData.firstName = _firstNameController.text.trim();
    widget.profileData.lastName = _lastNameController.text.trim();
    final l10n = context.l10n;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationSuccessScreen(
          title: l10n.congratulationsTitle,
          description:
              '${l10n.welcome}, ${widget.profileData.firstName}! ${l10n.memberProfileCompletedSubtitle}',
          firstName: widget.profileData.firstName,
          phone: widget.profileData.displayPhone,
          destinationScreen: MemberHomeScreen(
            profileData: widget.profileData,
          ),
        ),
      ),
    );
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horizontal Stepper Bar (Step X of 2)
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
                    if (_currentStep == 1)
                      _buildStep1Names(theme, l10n, isDark),
                    if (_currentStep == 2)
                      _buildStep2DobGender(theme, l10n, isDark),

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
            title: l10n.personalInfoSection,
            subtitle: l10n.memberNamesSubtitle,
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
          title: l10n.dobStepTitle,
          subtitle: l10n.dobStepSubtitle,
          isDark: isDark,
        ),
        const SizedBox(height: 24),

        // Custom Date Picker Field with 18+ enforcement
        CustomDatePickerField(
          label: l10n.dateOfBirth,
          hintText: l10n.dateOfBirthHint,
          selectedDate: widget.profileData.dob,
          require18Plus: true,
          helperText: l10n.dobAgeRequirement,
          onDateSelected: (date) {
            setState(() {
              widget.profileData.dob = date;
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
                isSelected: widget.profileData.gender == 'Male',
                isDark: isDark,
                onTap: () => setState(() => widget.profileData.gender = 'Male'),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildGenderChoice(
                label: l10n.female,
                icon: Icons.female_rounded,
                isSelected: widget.profileData.gender == 'Female',
                isDark: isDark,
                onTap: () =>
                    setState(() => widget.profileData.gender = 'Female'),
              ),
            ),
          ],
        ),
      ],
    );
  }

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

  // Gender Option Card matching Kijumbe CompleteProfileScreen
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

  // Floating Bottom Action Bar matching Kijumbe CompleteProfileScreen
  Widget _buildBottomActionBar(ThemeData theme, dynamic l10n, bool isDark) {
    final isLastStep = _currentStep == _totalSteps;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: Row(
        children: [
          if (_currentStep > 1) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _onPreviousStep,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26)),
                  side: BorderSide(
                     color: isDark ? Colors.white24 : Colors.grey[400]!,
                  ),
                ),
                child: Text(
                  l10n.back,
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
              text: isLastStep
                  ? l10n.completeRegistrationBtn
                  : l10n.continueText,
              height: 52,
              borderRadius: 26,
              onPressed: _onNextStep,
            ),
          ),
        ],
      ),
    );
  }
}
