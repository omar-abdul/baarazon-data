import '../database/sqlite_db.dart';

class ServicesDbHelper {
  final SqliteDb db;
  const ServicesDbHelper({required this.db});

  Future<int> insert(ServiceModel service) async {
    return await db.insert('services', service.toMap());
  }

  Future<List<ServiceModel>> getAllServicesByProviderId(int providerId) async {
    final services = await db
        .query('services', where: 'provider_id = ?', whereArgs: [providerId]);
    return services.map((service) => ServiceModel.fromMap(service)).toList();
  }
}

class ServiceModel {
  final int? id; // nullable for new records
  final int providerId;
  final String name;
  final num costPrice;
  final num advertisedPrice;
  final String description;
  final String type;
  final String currency;

  ServiceModel({
    this.id,
    required this.providerId,
    required this.name,
    required this.costPrice,
    required this.advertisedPrice,
    required this.description,
    required this.type,
    required this.currency,
  });

  // Create from database map
  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] as int,
      providerId: map['provider_id'] as int,
      name: map['name'] as String,
      costPrice: map['cost_price'],
      advertisedPrice: map['advertised_price'],
      description: map['description'] as String,
      type: map['type'] as String,
      currency: map['currency'] as String,
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'provider_id': providerId,
      'name': name,
      'cost_price': costPrice,
      'advertised_price': advertisedPrice,
      'description': description,
      'type': type,
      'currency': currency,
    };
  }

  // Create copy with modifications
  ServiceModel copyWith({
    int? id,
    int? providerId,
    String? name,
    num? costPrice,
    num? advertisedPrice,
    String? description,
    String? type,
    String? ussdCode,
    String? currency,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      name: name ?? this.name,
      costPrice: costPrice ?? this.costPrice,
      advertisedPrice: advertisedPrice ?? this.advertisedPrice,
      description: description ?? this.description,
      type: type ?? this.type,
      currency: currency ?? this.currency,
    );
  }

  @override
  String toString() {
    return 'ServiceModel('
        'id: $id, '
        'providerId: $providerId, '
        'name: $name, '
        'costPrice: $costPrice, '
        'advertisedPrice: $advertisedPrice, '
        'description: $description, '
        'type: $type, '
        'currency: $currency'
        ')';
  }
}
