import '../../../../core/components/custom_date_picker.dart';

/// Data model holding state across the stretched 6-step Complete Profile registration flow.
class ProfileRegistrationData {
  // Step 1: Legal Names
  String firstName;
  String? middleName;
  String lastName;

  // Step 2: Date of Birth & Gender
  DateTime? dob;
  String gender; // 'Male' or 'Female'

  // Step 3: Residential Address & Stay Location
  String country;
  String city;
  String streetAddress;
  double? latitude;
  double? longitude;
  String? pinpointAddress;

  // Step 4: NIDA Identity Verification
  String nin; // 20 raw digits
  bool isNidaVerified;
  int questionsAnsweredCount;
  int questionsPassedCount;

  // Step 5: Mobile Phone Number
  String countryCode;
  String phone;
  String fullPhone;

  // Step 6: Phone OTP Verification
  String otpCode;
  bool isPhoneVerified;

  ProfileRegistrationData({
    this.firstName = '',
    this.middleName,
    this.lastName = '',
    this.dob,
    this.gender = 'Male',
    this.country = 'Tanzania',
    this.city = 'Dar es Salaam',
    this.streetAddress = '',
    this.latitude,
    this.longitude,
    this.pinpointAddress,
    this.nin = '',
    this.isNidaVerified = false,
    this.questionsAnsweredCount = 0,
    this.questionsPassedCount = 0,
    this.countryCode = '+255',
    this.phone = '',
    this.fullPhone = '',
    this.otpCode = '',
    this.isPhoneVerified = false,
  });

  String get displayPhone {
    if (fullPhone.isNotEmpty) return fullPhone;
    if (phone.isNotEmpty) return '$countryCode $phone';
    return '';
  }

  // Step 1: Names
  bool get isStep1Valid =>
      firstName.trim().isNotEmpty && lastName.trim().isNotEmpty;

  // Step 2: DOB & Gender
  bool get isStep2Valid =>
      dob != null && DateValidationUtils.is18OrOlder(dob!);

  // Step 3: Address & Location
  bool get isStep3Valid =>
      country.trim().isNotEmpty &&
      city.trim().isNotEmpty &&
      streetAddress.trim().isNotEmpty;

  // Step 4: NIDA Identity
  bool get isStep4Valid => isNidaVerified;

  // Step 5: Phone Number
  bool get isStep5Valid {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length == 9;
  }

  // Step 6: Phone OTP
  bool get isStep6Valid => isPhoneVerified || otpCode.trim().length == 6;
}
