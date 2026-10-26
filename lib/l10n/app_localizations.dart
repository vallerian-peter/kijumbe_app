import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Kijumbe'**
  String get appName;

  /// Tagline of the application
  ///
  /// In en, this message translates to:
  /// **'Save Together, Grow Together'**
  String get appTagline;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @contributions.
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get contributions;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @myContributions.
  ///
  /// In en, this message translates to:
  /// **'My Contributions'**
  String get myContributions;

  /// No description provided for @activeGames.
  ///
  /// In en, this message translates to:
  /// **'Active Games'**
  String get activeGames;

  /// No description provided for @upcomingRounds.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Rounds'**
  String get upcomingRounds;

  /// No description provided for @joinGroup.
  ///
  /// In en, this message translates to:
  /// **'Join Group'**
  String get joinGroup;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network connection error. Please check your internet.'**
  String get networkError;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get somethingWentWrong;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @swahili.
  ///
  /// In en, this message translates to:
  /// **'Swahili (Kiswahili)'**
  String get swahili;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemTheme;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @getStartedHeadline.
  ///
  /// In en, this message translates to:
  /// **'Save Together.\nReceive With Confidence.'**
  String get getStartedHeadline;

  /// No description provided for @getStartedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore how Kijumbe works, track group savings insights, and launch your own circle in minutes.'**
  String get getStartedSubtitle;

  /// No description provided for @iAlreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get iAlreadyHaveAnAccount;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguageTitle;

  /// No description provided for @chooseLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language to continue. You can change this anytime in settings.'**
  String get chooseLanguageSubtitle;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you started with Kijumbe, where all Group Savings and Tracking happens.'**
  String get createAccountSubtitle;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'your@gmail.com'**
  String get emailHint;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email address is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @createStrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Create Strong Password'**
  String get createStrongPassword;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Password does not meet all the requirements'**
  String get passwordInvalid;

  /// No description provided for @passwordMustContain.
  ///
  /// In en, this message translates to:
  /// **'Password must contain the following:'**
  String get passwordMustContain;

  /// No description provided for @passwordMinChars.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters long'**
  String get passwordMinChars;

  /// No description provided for @passwordUppercase.
  ///
  /// In en, this message translates to:
  /// **'At least one uppercase letter'**
  String get passwordUppercase;

  /// No description provided for @passwordLowercase.
  ///
  /// In en, this message translates to:
  /// **'At least one lowercase letter'**
  String get passwordLowercase;

  /// No description provided for @passwordNumber.
  ///
  /// In en, this message translates to:
  /// **'At least one number'**
  String get passwordNumber;

  /// No description provided for @passwordSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'At least one special character'**
  String get passwordSpecialChar;

  /// No description provided for @loginHere.
  ///
  /// In en, this message translates to:
  /// **'Login Here'**
  String get loginHere;

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get completeProfileTitle;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell Us About Yourself'**
  String get tellUsAboutYourself;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameHint;

  /// No description provided for @middleNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Middle name (optional)'**
  String get middleNameOptional;

  /// No description provided for @middleNameHint.
  ///
  /// In en, this message translates to:
  /// **'Middle Name'**
  String get middleNameHint;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameHint;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @dateOfBirthHint.
  ///
  /// In en, this message translates to:
  /// **'mm/dd/yyyy'**
  String get dateOfBirthHint;

  /// No description provided for @dobAgeRequirement.
  ///
  /// In en, this message translates to:
  /// **'You must be 18 or older to use this service'**
  String get dobAgeRequirement;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @dobRequired.
  ///
  /// In en, this message translates to:
  /// **'Date of birth is required'**
  String get dobRequired;

  /// No description provided for @underAgeError.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 18 years old to register'**
  String get underAgeError;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @genderRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender'**
  String get genderRequired;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'712 345 678'**
  String get phoneNumberHint;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @residentialAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Residential Address'**
  String get residentialAddressTitle;

  /// No description provided for @residentialAddressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your stay location and pinpoint on the map for verified delivery and service.'**
  String get residentialAddressSubtitle;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @countryHint.
  ///
  /// In en, this message translates to:
  /// **'Tanzania'**
  String get countryHint;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City / Region'**
  String get city;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Dar es Salaam'**
  String get cityHint;

  /// No description provided for @cityRequired.
  ///
  /// In en, this message translates to:
  /// **'City / Region is required'**
  String get cityRequired;

  /// No description provided for @streetAddress.
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get streetAddress;

  /// No description provided for @streetAddressHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Mwai Kibaki Rd, Plot 42'**
  String get streetAddressHint;

  /// No description provided for @streetAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Street address is required'**
  String get streetAddressRequired;

  /// No description provided for @locationPinpointTitle.
  ///
  /// In en, this message translates to:
  /// **'Pinpoint Location'**
  String get locationPinpointTitle;

  /// No description provided for @pinpointLocationBtn.
  ///
  /// In en, this message translates to:
  /// **'Pinpoint Location on Map'**
  String get pinpointLocationBtn;

  /// No description provided for @locationSelected.
  ///
  /// In en, this message translates to:
  /// **'Location Pinpointed'**
  String get locationSelected;

  /// No description provided for @locationNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Tap to select location on map'**
  String get locationNotSelected;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Please pinpoint your location on the map'**
  String get locationRequired;

  /// No description provided for @searchAddressPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search area, street, or landmark...'**
  String get searchAddressPlaceholder;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @nidaVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'NIDA Identity Verification'**
  String get nidaVerificationTitle;

  /// No description provided for @nidaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your 20-digit National ID and answer up to 5 security questions to verify your account.'**
  String get nidaSubtitle;

  /// No description provided for @nidaNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'National Identification Number (NIN)'**
  String get nidaNumberLabel;

  /// No description provided for @nidaNumberHint.
  ///
  /// In en, this message translates to:
  /// **'19XXXXXXXXXXXXX00000'**
  String get nidaNumberHint;

  /// No description provided for @nidaNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'NIDA number is required'**
  String get nidaNumberRequired;

  /// No description provided for @nidaNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'NIDA number must be 20 digits'**
  String get nidaNumberInvalid;

  /// No description provided for @nidaQuestionNotice.
  ///
  /// In en, this message translates to:
  /// **'Answer at least 3 of 5 security questions correctly to automatically verify your identity.'**
  String get nidaQuestionNotice;

  /// No description provided for @nidaQuestionBadge.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get nidaQuestionBadge;

  /// No description provided for @questionsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questionsCountLabel;

  /// No description provided for @nidaAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Answer'**
  String get nidaAnswerLabel;

  /// No description provided for @nidaAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Type your answer here'**
  String get nidaAnswerHint;

  /// No description provided for @nidaAnswerRequired.
  ///
  /// In en, this message translates to:
  /// **'Please provide an answer or tap Skip'**
  String get nidaAnswerRequired;

  /// No description provided for @submitAnswer.
  ///
  /// In en, this message translates to:
  /// **'Submit Answer'**
  String get submitAnswer;

  /// No description provided for @skipQuestion.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipQuestion;

  /// No description provided for @nidaVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Identity verified successfully!'**
  String get nidaVerifiedSuccess;

  /// No description provided for @reviewProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Your Profile'**
  String get reviewProfileTitle;

  /// No description provided for @reviewProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please verify your information before finishing setup.'**
  String get reviewProfileSubtitle;

  /// No description provided for @personalInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfoSection;

  /// No description provided for @addressLocationSection.
  ///
  /// In en, this message translates to:
  /// **'Address & Location'**
  String get addressLocationSection;

  /// No description provided for @nidaVerifiedSection.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification'**
  String get nidaVerifiedSection;

  /// No description provided for @nidaStatusVerified.
  ///
  /// In en, this message translates to:
  /// **'NIDA Verified'**
  String get nidaStatusVerified;

  /// No description provided for @completeRegistrationBtn.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get completeRegistrationBtn;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @phoneVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Verification'**
  String get phoneVerificationTitle;

  /// No description provided for @phoneVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code sent to your mobile phone.'**
  String get phoneVerificationSubtitle;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in'**
  String get resendCodeIn;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @verifyAndComplete.
  ///
  /// In en, this message translates to:
  /// **'Verify & Complete'**
  String get verifyAndComplete;

  /// No description provided for @otpRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete 6-digit OTP code'**
  String get otpRequired;

  /// No description provided for @profileCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Completed!'**
  String get profileCompletedTitle;

  /// No description provided for @profileCompletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Your identity and phone number have been verified successfully.'**
  String get profileCompletedMsg;

  /// No description provided for @legalNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your legal names matching your official NIDA ID card.'**
  String get legalNameSubtitle;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneInvalid;

  /// No description provided for @dobStepTitle.
  ///
  /// In en, this message translates to:
  /// **'When were you born?'**
  String get dobStepTitle;

  /// No description provided for @dobStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your birth date and gender. You must be 18+ to register.'**
  String get dobStepSubtitle;

  /// No description provided for @yearsOld.
  ///
  /// In en, this message translates to:
  /// **'yrs old'**
  String get yearsOld;

  /// No description provided for @updatePinpoint.
  ///
  /// In en, this message translates to:
  /// **'Update Pinpoint'**
  String get updatePinpoint;

  /// No description provided for @locationPinpointedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Location pinpointed successfully!'**
  String get locationPinpointedSuccess;

  /// No description provided for @pinpointStayAddressDesc.
  ///
  /// In en, this message translates to:
  /// **'Search or use device GPS to pinpoint your stay location'**
  String get pinpointStayAddressDesc;

  /// No description provided for @nidaCompleteRequired.
  ///
  /// In en, this message translates to:
  /// **'Please complete NIDA verification to continue'**
  String get nidaCompleteRequired;

  /// No description provided for @nidaVerifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify with NIDA (Answer Question)'**
  String get nidaVerifyButton;

  /// No description provided for @nidaSecurityNotice.
  ///
  /// In en, this message translates to:
  /// **'Answer the security question from your NIDA registration profile to instantly verify your account.'**
  String get nidaSecurityNotice;

  /// No description provided for @reVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify Again'**
  String get reVerify;

  /// No description provided for @nidaAnswerPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter an answer to verify your identity'**
  String get nidaAnswerPrompt;

  /// No description provided for @enterFullNinFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enter a full 20-digit NIDA number first'**
  String get enterFullNinFirst;

  /// No description provided for @phoneStepTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your phone number?'**
  String get phoneStepTitle;

  /// No description provided for @phoneStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We will send a 6-digit SMS code to verify your mobile number in the next step.'**
  String get phoneStepSubtitle;

  /// No description provided for @mobilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Phone Number'**
  String get mobilePhoneLabel;

  /// No description provided for @smsVerificationNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'SMS Verification Required'**
  String get smsVerificationNoticeTitle;

  /// No description provided for @smsVerificationNoticeMsg.
  ///
  /// In en, this message translates to:
  /// **'Ensure this number is active and capable of receiving SMS messages.'**
  String get smsVerificationNoticeMsg;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to'**
  String get verificationCodeSent;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get didntReceiveCode;

  /// No description provided for @otpEnteredSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP entered successfully!'**
  String get otpEnteredSuccess;

  /// No description provided for @goToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get goToDashboard;

  /// No description provided for @underAgeNotice.
  ///
  /// In en, this message translates to:
  /// **'Applicant must be 18 years or older to proceed.'**
  String get underAgeNotice;

  /// No description provided for @pinpointStayAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Pinpoint Stay Address'**
  String get pinpointStayAddressTitle;

  /// No description provided for @detectingGps.
  ///
  /// In en, this message translates to:
  /// **'Detecting GPS...'**
  String get detectingGps;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected Location'**
  String get selectedLocation;

  /// No description provided for @popularAreasInDar.
  ///
  /// In en, this message translates to:
  /// **'Popular Areas in Dar es Salaam'**
  String get popularAreasInDar;

  /// No description provided for @enterOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code sent to'**
  String get enterOtpSentTo;

  /// No description provided for @newCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'A new 6-digit verification code has been sent to'**
  String get newCodeSentTo;

  /// No description provided for @nidaSecurityNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'NIDA Security Verification'**
  String get nidaSecurityNoticeTitle;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @registrationSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful!'**
  String get registrationSuccessTitle;

  /// No description provided for @registrationSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your identity and phone number have been verified. Your Kijumbe account is ready.'**
  String get registrationSuccessSubtitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone number associated with your account. We will send an OTP code to reset your password.'**
  String get forgotPasswordInstruction;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP Code'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @otpVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Phone Number'**
  String get otpVerificationTitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get newPasswordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get confirmPasswordHint;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a strong new password for your Kijumbe account.'**
  String get resetPasswordSubtitle;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset successfully! Please login with your new password.'**
  String get passwordResetSuccess;

  /// No description provided for @otpSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP code has been sent successfully!'**
  String get otpSentSuccess;

  /// No description provided for @otpVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone number verified successfully!'**
  String get otpVerifiedSuccess;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @passwordsMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get passwordsMatch;

  /// No description provided for @loginToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Login to Your Account'**
  String get loginToYourAccount;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to login to our Kijumbe app.'**
  String get loginSubtitle;

  /// No description provided for @acceptTermsAndPrivacyWarning.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms & Conditions and Privacy Policy to continue.'**
  String get acceptTermsAndPrivacyWarning;

  /// No description provided for @termsAgreementPrefix.
  ///
  /// In en, this message translates to:
  /// **'By clicking continuing, you have agreed to our '**
  String get termsAgreementPrefix;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @andAlsoAbideWithOur.
  ///
  /// In en, this message translates to:
  /// **' and abide with our '**
  String get andAlsoAbideWithOur;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @registerHere.
  ///
  /// In en, this message translates to:
  /// **'Register here'**
  String get registerHere;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @activeGroups.
  ///
  /// In en, this message translates to:
  /// **'Active Groups'**
  String get activeGroups;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @pendingContributions.
  ///
  /// In en, this message translates to:
  /// **'Pending Contributions'**
  String get pendingContributions;

  /// No description provided for @depositFunds.
  ///
  /// In en, this message translates to:
  /// **'Deposit Funds'**
  String get depositFunds;

  /// No description provided for @sendMoney.
  ///
  /// In en, this message translates to:
  /// **'Send Money'**
  String get sendMoney;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @createNewGroup.
  ///
  /// In en, this message translates to:
  /// **'Create new Group'**
  String get createNewGroup;

  /// No description provided for @groupDetails.
  ///
  /// In en, this message translates to:
  /// **'Group Details'**
  String get groupDetails;

  /// No description provided for @myGroups.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get myGroups;

  /// No description provided for @targetPool.
  ///
  /// In en, this message translates to:
  /// **'Target Pool'**
  String get targetPool;

  /// No description provided for @membersPaid.
  ///
  /// In en, this message translates to:
  /// **'Members Paid'**
  String get membersPaid;

  /// No description provided for @currentRound.
  ///
  /// In en, this message translates to:
  /// **'Current Round'**
  String get currentRound;

  /// No description provided for @nextPayout.
  ///
  /// In en, this message translates to:
  /// **'Next Payout'**
  String get nextPayout;

  /// No description provided for @contributionProgress.
  ///
  /// In en, this message translates to:
  /// **'Contribution Progress'**
  String get contributionProgress;

  /// No description provided for @makeContribution.
  ///
  /// In en, this message translates to:
  /// **'Make Contribution'**
  String get makeContribution;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMember;

  /// No description provided for @quickInviteByPhone.
  ///
  /// In en, this message translates to:
  /// **'Quick Invite by Phone'**
  String get quickInviteByPhone;

  /// No description provided for @groupRulesAndTerms.
  ///
  /// In en, this message translates to:
  /// **'Group Rules & Terms'**
  String get groupRulesAndTerms;

  /// No description provided for @shareGroupLink.
  ///
  /// In en, this message translates to:
  /// **'Share Group Link'**
  String get shareGroupLink;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get biometricLogin;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @pinnedLocation.
  ///
  /// In en, this message translates to:
  /// **'Pinned Location'**
  String get pinnedLocation;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center & FAQ'**
  String get helpCenter;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @identification.
  ///
  /// In en, this message translates to:
  /// **'Identification'**
  String get identification;

  /// No description provided for @nidaNumber.
  ///
  /// In en, this message translates to:
  /// **'NIDA Number'**
  String get nidaNumber;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// No description provided for @contribute.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contribute;

  /// No description provided for @contributionAmount.
  ///
  /// In en, this message translates to:
  /// **'Contribution'**
  String get contributionAmount;

  /// No description provided for @groupCapacity.
  ///
  /// In en, this message translates to:
  /// **'Group Capacity'**
  String get groupCapacity;

  /// No description provided for @allGroups.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allGroups;

  /// No description provided for @activeTab.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeTab;

  /// No description provided for @pendingTab.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingTab;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// No description provided for @cashOut.
  ///
  /// In en, this message translates to:
  /// **'Cash Out'**
  String get cashOut;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @biWeekly.
  ///
  /// In en, this message translates to:
  /// **'Bi-weekly'**
  String get biWeekly;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @cycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get cycle;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get remaining;

  /// No description provided for @slotsPaid.
  ///
  /// In en, this message translates to:
  /// **'slots paid'**
  String get slotsPaid;

  /// No description provided for @remind.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get remind;

  /// No description provided for @reminderSentTo.
  ///
  /// In en, this message translates to:
  /// **'Reminder sent to'**
  String get reminderSentTo;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @contributeToMember.
  ///
  /// In en, this message translates to:
  /// **'Contribute to Member'**
  String get contributeToMember;

  /// No description provided for @selectRecipientMember.
  ///
  /// In en, this message translates to:
  /// **'Select Recipient Member'**
  String get selectRecipientMember;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @editField.
  ///
  /// In en, this message translates to:
  /// **'Edit {field}'**
  String editField(String field);

  /// No description provided for @fieldUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{field} updated successfully'**
  String fieldUpdatedSuccess(String field);

  /// No description provided for @updateFieldSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your {field} details below'**
  String updateFieldSubtitle(String field);

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @nidaInfoConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'NIDA Information Confirmation'**
  String get nidaInfoConfirmationTitle;

  /// No description provided for @nidaInfoConfirmationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please verify your official identity details retrieved from NIDA.'**
  String get nidaInfoConfirmationSubtitle;

  /// No description provided for @yourInformation.
  ///
  /// In en, this message translates to:
  /// **'Your Information'**
  String get yourInformation;

  /// No description provided for @officialIdPhoto.
  ///
  /// In en, this message translates to:
  /// **'Official ID Photo'**
  String get officialIdPhoto;

  /// No description provided for @verifiedByNida.
  ///
  /// In en, this message translates to:
  /// **'Verified by NIDA'**
  String get verifiedByNida;

  /// No description provided for @residentCity.
  ///
  /// In en, this message translates to:
  /// **'City / Region'**
  String get residentCity;

  /// No description provided for @ninLabel.
  ///
  /// In en, this message translates to:
  /// **'National ID (NIN)'**
  String get ninLabel;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @tanzanian.
  ///
  /// In en, this message translates to:
  /// **'Tanzanian'**
  String get tanzanian;

  /// No description provided for @verificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get verificationStatus;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @enterOtpToVerifyPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your phone number to complete account registration.'**
  String get enterOtpToVerifyPhone;

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verifyAndContinue;

  /// No description provided for @congratulationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulationsTitle;

  /// No description provided for @congratulationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your identity and phone number have been verified successfully. Your Kijumbe account is ready.'**
  String get congratulationsSubtitle;

  /// No description provided for @selectRegistrationType.
  ///
  /// In en, this message translates to:
  /// **'Select Account Type'**
  String get selectRegistrationType;

  /// No description provided for @selectRegistrationTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to join and experience Kijumbe'**
  String get selectRegistrationTypeSubtitle;

  /// No description provided for @kijumbeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Kijumbe (Leader)'**
  String get kijumbeRegistration;

  /// No description provided for @kijumbeRegistrationDesc.
  ///
  /// In en, this message translates to:
  /// **'Create & manage savings groups, approve members, and track cycles.'**
  String get kijumbeRegistrationDesc;

  /// No description provided for @memberRegistration.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get memberRegistration;

  /// No description provided for @memberRegistrationDesc.
  ///
  /// In en, this message translates to:
  /// **'Join existing groups with invite code, contribute, and request turn swaps.'**
  String get memberRegistrationDesc;

  /// No description provided for @enterGroupCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Group Code'**
  String get enterGroupCode;

  /// No description provided for @enterGroupCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. KJB-8492'**
  String get enterGroupCodeHint;

  /// No description provided for @pasteCode.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get pasteCode;

  /// No description provided for @joinGroupBtn.
  ///
  /// In en, this message translates to:
  /// **'Join Group'**
  String get joinGroupBtn;

  /// No description provided for @joiningGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Joining Group...'**
  String get joiningGroupTitle;

  /// No description provided for @joiningGroupDesc.
  ///
  /// In en, this message translates to:
  /// **'Verifying group code and setting up your membership. Please wait...'**
  String get joiningGroupDesc;

  /// No description provided for @groupJoinedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully joined group!'**
  String get groupJoinedSuccess;

  /// No description provided for @swapAppeal.
  ///
  /// In en, this message translates to:
  /// **'Swap Turn Appeal'**
  String get swapAppeal;

  /// No description provided for @swapAppealSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Request an earlier payout turn from another member'**
  String get swapAppealSubtitle;

  /// No description provided for @reasonForSwap.
  ///
  /// In en, this message translates to:
  /// **'Reason for Swap Appeal'**
  String get reasonForSwap;

  /// No description provided for @reasonForSwapHint.
  ///
  /// In en, this message translates to:
  /// **'State your reason (e.g. School fees, emergency medical expenses)'**
  String get reasonForSwapHint;

  /// No description provided for @reasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid reason for this appeal'**
  String get reasonRequired;

  /// No description provided for @submitAppeal.
  ///
  /// In en, this message translates to:
  /// **'Submit Appeal'**
  String get submitAppeal;

  /// No description provided for @appealSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your swap appeal has been submitted successfully.'**
  String get appealSubmitted;

  /// No description provided for @memberDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Member Portal'**
  String get memberDashboardTitle;

  /// No description provided for @joinedGroups.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get joinedGroups;

  /// No description provided for @noJoinedGroups.
  ///
  /// In en, this message translates to:
  /// **'You have not joined any group yet. Enter an invite code below to get started!'**
  String get noJoinedGroups;

  /// No description provided for @contributeNow.
  ///
  /// In en, this message translates to:
  /// **'Contribute Now'**
  String get contributeNow;

  /// No description provided for @contributionSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Contribution submitted successfully!'**
  String get contributionSuccessful;

  /// No description provided for @memberProfileCompletedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your member profile is complete! You can now join groups and save together.'**
  String get memberProfileCompletedSubtitle;

  /// No description provided for @memberNamesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your official personal names to complete your profile.'**
  String get memberNamesSubtitle;

  /// No description provided for @replacementAppeal.
  ///
  /// In en, this message translates to:
  /// **'Replacement Appeal'**
  String get replacementAppeal;

  /// No description provided for @replacementAppealSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Request your Kijumbe Leader to replace you in this circle'**
  String get replacementAppealSubtitle;

  /// No description provided for @reasonForReplacement.
  ///
  /// In en, this message translates to:
  /// **'Reason for Replacement Appeal'**
  String get reasonForReplacement;

  /// No description provided for @reasonForReplacementHint.
  ///
  /// In en, this message translates to:
  /// **'State your reason (e.g. Financial emergency, unable to continue contributions)'**
  String get reasonForReplacementHint;

  /// No description provided for @replacementSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your replacement appeal has been submitted to your Kijumbe Leader.'**
  String get replacementSubmitted;

  /// No description provided for @swapMemberTurns.
  ///
  /// In en, this message translates to:
  /// **'Swap Member Turns'**
  String get swapMemberTurns;

  /// No description provided for @swapMemberTurnsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reorder payout turns between two group members'**
  String get swapMemberTurnsSubtitle;

  /// No description provided for @swapTurnsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Turns swapped successfully between members'**
  String get swapTurnsSuccess;

  /// No description provided for @selectFirstMember.
  ///
  /// In en, this message translates to:
  /// **'Select First Member'**
  String get selectFirstMember;

  /// No description provided for @selectSecondMember.
  ///
  /// In en, this message translates to:
  /// **'Select Second Member'**
  String get selectSecondMember;

  /// No description provided for @confirmSwapTurns.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Swap Turns'**
  String get confirmSwapTurns;

  /// No description provided for @myPayoutTurn.
  ///
  /// In en, this message translates to:
  /// **'Your Payout Turn: #{turn}'**
  String myPayoutTurn(int turn);

  /// No description provided for @turnNumber.
  ///
  /// In en, this message translates to:
  /// **'Turn #{turn}'**
  String turnNumber(int turn);

  /// No description provided for @youHaveContributedThisRound.
  ///
  /// In en, this message translates to:
  /// **'You have contributed for this round'**
  String get youHaveContributedThisRound;

  /// No description provided for @pendingContributionRound.
  ///
  /// In en, this message translates to:
  /// **'Pending contribution for Round {round}'**
  String pendingContributionRound(int round);

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @selectMobileMoneyOperator.
  ///
  /// In en, this message translates to:
  /// **'Select Mobile Money Operator'**
  String get selectMobileMoneyOperator;

  /// No description provided for @mobileMoneyNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money Number'**
  String get mobileMoneyNumber;

  /// No description provided for @examples.
  ///
  /// In en, this message translates to:
  /// **'Examples:'**
  String get examples;

  /// No description provided for @logoutConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmationTitle;

  /// No description provided for @logoutConfirmationMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out from Kijumbe?'**
  String get logoutConfirmationMsg;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your security credentials'**
  String get changePasswordSubtitle;

  /// No description provided for @myTotalSavings.
  ///
  /// In en, this message translates to:
  /// **'My Total Savings'**
  String get myTotalSavings;

  /// No description provided for @kikobaMember.
  ///
  /// In en, this message translates to:
  /// **'Kikoba Member'**
  String get kikobaMember;

  /// No description provided for @membershipDetails.
  ///
  /// In en, this message translates to:
  /// **'Membership Details'**
  String get membershipDetails;

  /// No description provided for @groupBasics.
  ///
  /// In en, this message translates to:
  /// **'Group Basics'**
  String get groupBasics;

  /// No description provided for @contributionsAndSize.
  ///
  /// In en, this message translates to:
  /// **'Contributions & Size'**
  String get contributionsAndSize;

  /// No description provided for @rulesAndReview.
  ///
  /// In en, this message translates to:
  /// **'Rules & Review'**
  String get rulesAndReview;

  /// No description provided for @createAndInviteMembers.
  ///
  /// In en, this message translates to:
  /// **'Create & Invite Members'**
  String get createAndInviteMembers;

  /// No description provided for @groupInformation.
  ///
  /// In en, this message translates to:
  /// **'Group Information'**
  String get groupInformation;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @pleaseEnterGroupName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a group name'**
  String get pleaseEnterGroupName;

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid contribution amount'**
  String get pleaseEnterValidAmount;

  /// No description provided for @pleaseAgreeGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the group management guidelines'**
  String get pleaseAgreeGuidelines;

  /// No description provided for @inviteMembers.
  ///
  /// In en, this message translates to:
  /// **'Invite Members'**
  String get inviteMembers;

  /// No description provided for @growYourCircle.
  ///
  /// In en, this message translates to:
  /// **'Grow Your Circle'**
  String get growYourCircle;

  /// No description provided for @memberUsername.
  ///
  /// In en, this message translates to:
  /// **'Member Username'**
  String get memberUsername;

  /// No description provided for @pleaseEnterMemberUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter member username'**
  String get pleaseEnterMemberUsername;

  /// No description provided for @pleaseEnterMemberPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter member phone number'**
  String get pleaseEnterMemberPhone;

  /// No description provided for @personalInviteGenerated.
  ///
  /// In en, this message translates to:
  /// **'Personal invite link generated for {user}!'**
  String personalInviteGenerated(String user);

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'{label} copied to clipboard!'**
  String copiedToClipboard(String label);

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
