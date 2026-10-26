import 'package:package_info_plus/package_info_plus.dart';

/// Utility class for retrieving application and device package metadata
abstract class AppInfoHelper {
  /// Get full [PackageInfo] object from platform
  static Future<PackageInfo> getPackageInfo() async {
    return PackageInfo.fromPlatform();
  }

  /// Get formatted version info string: e.g. "v1.0.0+1" or "v1.0.0"
  static Future<String> getAppVersion({
    bool includeBuildNumber = true,
    String prefix = 'v',
  }) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version;
      final buildNumber = info.buildNumber;

      if (includeBuildNumber && buildNumber.isNotEmpty) {
        return '$prefix$version+$buildNumber';
      }
      return '$prefix$version';
    } catch (_) {
      return '${prefix}1.0.0';
    }
  }

  /// Get version name (e.g. "1.0.0")
  static Future<String> getVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (_) {
      return '1.0.0';
    }
  }

  /// Get build number (e.g. "1")
  static Future<String> getBuildNumber() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.buildNumber;
    } catch (_) {
      return '1';
    }
  }

  /// Get app name
  static Future<String> getAppName() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.appName;
    } catch (_) {
      return '';
    }
  }

  /// Get package / bundle identifier
  static Future<String> getPackageName() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.packageName;
    } catch (_) {
      return '';
    }
  }
}
