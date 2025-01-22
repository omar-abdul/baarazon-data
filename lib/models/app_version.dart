class AppVersion {
  final String versionCode;
  final String versionName;
  final bool forceUpdate;
  final DateTime releaseDate;
  final AppStoreLinks appLinks;

  AppVersion({
    required this.versionCode,
    required this.versionName,
    required this.forceUpdate,
    required this.releaseDate,
    required this.appLinks,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      versionCode: json['appVersion']['version_code'],
      versionName: json['appVersion']['version_name'],
      forceUpdate: json['appVersion']['force_update'],
      releaseDate: DateTime.parse(json['appVersion']['release_date']),
      appLinks: AppStoreLinks.fromJson(json['appLinks']),
    );
  }
}

class AppStoreLinks {
  final int id;
  final String platform;
  final String storeUrl;

  AppStoreLinks({
    required this.id,
    required this.platform,
    required this.storeUrl,
  });

  factory AppStoreLinks.fromJson(Map<String, dynamic> json) {
    return AppStoreLinks(
      id: json['id'],
      platform: json['platform'],
      storeUrl: json['store_url'],
    );
  }
}
