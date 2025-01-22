import '../database/sqlite_db.dart';

class ProviderDbHelper {
  final SqliteDb db;
  const ProviderDbHelper({required this.db});

  Future<int> insert(ProviderModel provider) async {
    return await db.insert('providers', provider.toMap());
  }

  Future<List<ProviderModel>> getAllByRegion(String region) async {
    final providers =
        await db.query('providers', where: 'region = ?', whereArgs: [region]);

    return providers
        .map((provider) => ProviderModel.fromMap(provider))
        .toList();
  }

  Future<ProviderModel?> getProvider(int id) async {
    final provider =
        await db.query('providers', where: 'id = ?', whereArgs: [id]);
    return provider
        .map((provider) => ProviderModel.fromMap(provider))
        .firstOrNull;
  }
}

class ProviderModel {
  final int? id; // nullable for new records
  final String name;
  final bool available;
  final String imagePath;
  final String displayName;
  final bool showInApp;
  final String region;

  ProviderModel({
    this.id,
    required this.name,
    required this.available,
    this.imagePath = '/assets/company_logo/placeholder.png',
    required this.displayName,
    this.showInApp = true,
    required this.region,
  });

  // Create from database map
  factory ProviderModel.fromMap(Map<String, dynamic> map) {
    return ProviderModel(
      id: map['id'] as int,
      name: map['name'] as String,
      available: map['available'] == 1,
      imagePath: map['image_path'] as String,
      displayName: map['display_name'] as String,
      showInApp: map['show_in_app'] == 1,
      region: map['region'] as String,
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'available': available ? 1 : 0,
      'image_path': imagePath,
      'display_name': displayName,
      'show_in_app': showInApp ? 1 : 0,
      'region': region,
    };
  }

  // Create copy with modifications
  ProviderModel copyWith({
    int? id,
    String? name,
    bool? available,
    String? imagePath,
    String? displayName,
    bool? showInApp,
    String? region,
  }) {
    return ProviderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      available: available ?? this.available,
      imagePath: imagePath ?? this.imagePath,
      displayName: displayName ?? this.displayName,
      showInApp: showInApp ?? this.showInApp,
      region: region ?? this.region,
    );
  }
}
