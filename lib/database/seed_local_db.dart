import 'sqlite_db.dart';

class SeedLocalDb {
  final SqliteDb _db = SqliteDb();

  Future<void> seedProviders() async {
    const seedQuery = '''
INSERT INTO providers (
  id, 
  name, 
  available, 
  image_path, 
  display_name, 
  show_in_app, 
  region
) VALUES 
(1, 'SOM PL', 1, 'assets/company_logo/somtel.png', 'Somtel', 1, 'PUNTLAND'),
(2, 'SOM MOG', 0, 'assets/company_logo/somtel.png', 'Somtel', 1, 'SOUTH SOMALIA'),
(3, 'AMTEL PL', 0, 'assets/company_logo/amtel.png', 'Amtel', 1, 'PUNTLAND'),
(4, 'DURDUR PL', 0, 'assets/company_logo/durdur.png', 'Durdur', 1, 'PUNTLAND');
    ''';

    final database = await _db.database;
    await database.execute(seedQuery);
  }

  Future<void> seedServices() async {
    const seedQuery = '''
    INSERT INTO services (
      id,
      provider_id, 
      name, 
      cost_price, 
      advertised_price, 
      description, 
      type,
      currency
    ) VALUES 
    (1, 1, 'DALMAR', 2.50, 2.47, 'Ku hadal 1\$ 30 cisho', 'PREPAID', 'USD'),
    (2, 1, 'UNLIMITED MALINLE', 0.50, 0.47, 'Unlimited Malinle', 'UNLIMITED', 'USD'),
    (3, 1, 'Unlimited Bile', 17.00, 16.80, 'Unlimited Bille 30 cisho', 'UNLIMITED', 'USD'),
    (4, 1, 'Maalinle 500', 0.25, 0.23, '500MB for 24hrs', 'XADAYSAN', 'USD'),
    (5, 1, 'Xirmo Bille', 4.00, 3.95, '546MB Daily', 'XADAYSAN', 'USD'),
    (6, 1, 'Xirmo bille', 9.00, 8.95, '1GB Daily', 'XADAYSAN', 'USD'),
    (7, 1, 'Asbuucle', 0.25, 0.24, '400MB Asbuucle', 'ASBUUCLE', 'USD'),
    (8, 1, 'Asbuucle', 0.50, 0.45, '1.5GB Asbuucle', 'ASBUUCLE', 'USD'),
    (9, 1, 'Asbuucle', 1.00, 0.98, '4GB Asbuucle', 'ASBUUCLE', 'USD'),
    (10, 1, 'Asbuucle', 2.50, 2.47, 'Unlimited Asbuucle', 'ASBUUCLE', 'USD'),
    (11, 1, 'Xidhmo Furan', 0.25, 0.23, '200MB Xirmo Furan', 'XIRMO FURAN', 'USD'),
    (12, 1, 'Xidhmo Furan', 0.50, 0.47, '500MB Xirmo Furan', 'XIRMO FURAN', 'USD'),
    (13, 1, 'Xidhmo Furan', 1.00, 0.97, '1GB Xidhmo Furan', 'XIRMO FURAN', 'USD'),
    (14, 1, 'Xidhmo Furan', 5.00, 4.98, '25GB Xidhmo Furan', 'XIRMO FURAN', 'USD'),
    (15, 1, 'Xidhmo Furan', 10.00, 9.97, '60GB Xidhmo Furan', 'XIRMO FURAN', 'USD'),
    (16, 1, 'Prepaid', 1.00, 0.98, 'Prepaid', 'PREPAID', 'USD');
    ''';

    final database = await _db.database;
    await database.execute(seedQuery);
  }

  Future<void> seedTimeSync() async {
    const seedQuery = '''
    INSERT INTO sync_info (table_name, last_sync) VALUES ('providers', '2025-01-12 12:00:00'),
    ('services', '2025-01-12 12:00:00');
    ''';

    final database = await _db.database;
    await database.execute(seedQuery);
  }

  Future<void> seedAll() async {
    await seedProviders();
    await seedServices();
    await seedTimeSync();
  }
}
