import 'package:package_info_plus/package_info_plus.dart';
import '../models/app_version.dart';
import 'http_service.dart';

class AppVersionService {
  final _http = HttpService();
  static const _checkInterval = Duration(hours: 24); // Configurable interval
  DateTime? _lastCheck;
  AppVersion? _cachedVersion;

  bool _compareVersions(String currentVersion, String newVersion) {
    // Split version strings into parts
    final current = currentVersion.split('.');
    final latest = newVersion.split('.');

    // Compare each part of the version number
    for (var i = 0; i < latest.length; i++) {
      // If current version is shorter, treat missing parts as 0
      final currentPart = i < current.length ? int.parse(current[i]) : 0;
      final latestPart = int.parse(latest[i]);

      if (latestPart > currentPart) {
        return true; // New version is higher
      } else if (latestPart < currentPart) {
        return false; // Current version is higher
      }
      // If equal, continue to next part
    }

    // If we get here, versions are equal
    return false;
  }

  Future<AppVersionCheck> checkVersion() async {
    try {
      // Get current app version
      final currentVersion = await PackageInfo.fromPlatform();

      // Check if we need to fetch from API
      if (_shouldCheck()) {
        _cachedVersion = await getAppVersion();
        _lastCheck = DateTime.now();
      }

      if (_cachedVersion == null) return AppVersionCheck(needsUpdate: false);

      return AppVersionCheck(
        needsUpdate: _compareVersions(
            currentVersion.version, _cachedVersion!.versionName),
        forceUpdate: _cachedVersion!.forceUpdate,
        appVersion: _cachedVersion!,
      );
    } catch (e) {
      return AppVersionCheck(needsUpdate: false);
    }
  }

  bool _shouldCheck() {
    if (_lastCheck == null || _cachedVersion == null) return true;
    return DateTime.now().difference(_lastCheck!) > _checkInterval;
  }

  Future<AppVersion> getAppVersion() async {
    final response = await _http.get<AppVersion, Map<String, dynamic>>(
      '/app_version',
      fromJson: (json) => AppVersion.fromJson(json['data']),
      acceptedCodes: {200},
    );

    return response;
  }
}

class AppVersionCheck {
  final bool needsUpdate;
  final bool forceUpdate;
  final AppVersion? appVersion;

  AppVersionCheck({
    required this.needsUpdate,
    this.forceUpdate = false,
    this.appVersion,
  });
}
