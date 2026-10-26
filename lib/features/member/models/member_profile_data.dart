class MemberProfileData {
  String phone;
  String countryCode;
  String password;
  bool isPhoneVerified;

  String firstName;
  String lastName;
  DateTime? dob;
  String gender;

  MemberProfileData({
    this.phone = '',
    this.countryCode = '+255',
    this.password = '',
    this.isPhoneVerified = false,
    this.firstName = '',
    this.lastName = '',
    this.dob,
    this.gender = 'Male',
  });

  String get displayPhone {
    if (phone.isEmpty) return '';
    final raw = phone.replaceAll(RegExp(r'\D'), '');
    if (raw.length == 9) {
      return '$countryCode ${raw.substring(0, 3)} ${raw.substring(3, 6)} ${raw.substring(6)}';
    }
    return '$countryCode $phone';
  }

  String get fullName {
    return [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
  }
}
