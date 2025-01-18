import '../database/sqlite_db.dart';

class SeedLocalDb {
  final SqliteDb _db = SqliteDb();

  Future<void> seedProviders() async {
    const seedQuery = '''
      INSERT INTO providers 
      (id, name, percentage_profit, available, image_path, display_name, show_in_app, region) 
      VALUES 
      (1, 'SOM PL', 17.00, 1, 'assets/company_logo/somtel.png', 'Somtel', 1, 'PUNTLAND'),
      (2, 'SOM MOG', 17.00, 0, 'assets/company_logo/somtel.png', 'Somtel', 1, 'SOUTH SOMALIA'),
      (3, 'AMTEL PL', 35.00, 0, 'assets/company_logo/amtel.png', 'Amtel', 1, 'PUNTLAND'),
      (4, 'DURDUR PL', 0.00, 0, 'assets/company_logo/durdur.png', 'Durdur', 1, 'PUNTLAND');
    ''';

    final database = await _db.database;
    await database.execute(seedQuery);
  }

  Future<void> seedServices() async {
    const seedQuery = '''
      INSERT INTO services 
      (id, provider_id, name, cost_price, advertised_price, description, type, ussd_code) 
      VALUES 
      (1, 1, 'DALMAR', 2.50, 2.47, 'Ku hadal 1\$ 30 cisho', 'PREPAID', '*138*{number}{amount}{pin}#'),
      (2, 1, 'UNLIMITED MALINLE', 0.50, 0.47, 'Unlimited Malinle', 'UNLIMITED', '*138*{number}{amount}{pin}#'),
      (3, 1, 'Unlimited Bile', 17.00, 16.80, 'Unlimited Bille 30 cisho', 'UNLIMITED', '*138*{number}{amount}{pin}#'),
      (4, 1, 'Maalinle 500', 0.25, 0.23, '500MB for 24hrs', 'XADAYSAN', '*136{number}{amount}{pin}#'),
      (5, 1, 'Xirmo Bille', 4.00, 3.95, '546MB Daily', 'XADAYSAN', '*136*{number}{amount}{pin}#'),
      (6, 1, 'Xirmo bille', 9.00, 8.95, '1GB Daily', 'XADAYSAN', '*136*{number}{amount}{pin}#'),
      (7, 1, 'Asbuucle', 0.25, 0.24, '400MB Asbuucle', 'ASBUUCLE', '*139*{number}{amount}{pin}#'),
      (8, 1, 'Asbuucle', 0.50, 0.45, '1.5GB Asbuucle', 'ASBUUCLE', '*139*{number}{amount}{pin}#'),
      (9, 1, 'Asbuucle', 1.00, 0.98, '4GB Asbuucle', 'ASBUUCLE', '*139*{number}{amount}{pin}#'),
      (10, 1, 'Asbuucle', 2.50, 2.47, 'Unlimited Asbuucle', 'ASBUUCLE', '*139*{number}2.5{pin}#'),
      (11, 1, 'Xidhmo Furan', 0.25, 0.23, '200MB Xirmo Furan', 'XIRMO FURAN', '*135*{number}{amount}{pin}#'),
      (12, 1, 'Xidhmo Furan', 0.50, 0.47, '500MB Xirmo Furan', 'XIRMO FURAN', '*135*{number}{amount}{pin}#'),
      (13, 1, 'Xidhmo Furan', 1.00, 0.97, '1GB Xidhmo Furan', 'XIRMO FURAN', '*135*{number}{amount}{pin}#'),
      (14, 1, 'Xidhmo Furan', 5.00, 4.98, '25GB Xidhmo Furan', 'XIRMO FURAN', '*135*{number}{amount}{pin}#'),
      (15, 1, 'Xidhmo Furan', 10.00, 9.97, '60GB Xidhmo Furan', 'XIRMO FURAN', '*135*{number}{amount}{pin}#'),
      (16, 1, 'Prepaid', 1.00, 0.98, 'Prepaid', 'PREPAID', '*129*{number}{amount}{pin}#');
    ''';

    final database = await _db.database;
    await database.execute(seedQuery);
  }

  Future<void> seedAll() async {
    await seedProviders();
    await seedServices();
  }
}
