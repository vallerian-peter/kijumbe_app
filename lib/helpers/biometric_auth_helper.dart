import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Helper utility for handling biometric authentication (Fingerprint, Face ID)
/// via the [LocalAuthentication] plugin.
class BiometricAuthHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Checks whether biometric authentication hardware is available on the device
  /// and whether biometric credentials (fingerprint/face) are currently enrolled.
  static Future<bool> isBiometricAvailable() async {
    try {
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      final availableBiometrics = await _auth.getAvailableBiometrics();
      return isSupported && canCheck && availableBiometrics.isNotEmpty;
    } on PlatformException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Triggers the native biometric authentication scanning pop-up.
  /// Returns `true` if authentication succeeded, `false` otherwise.
  static Future<bool> authenticate({
    String reason = 'Please authenticate to proceed with Kijumbe',
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return false;
      }

      return await _auth.authenticate(
        localizedReason: reason,
      );
    } on PlatformException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }
}
