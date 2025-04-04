import 'package:sqflite/sqflite.dart';

import '../database/sqlite_db.dart';
import '../logger.dart';
import 'http_service.dart';

class SyncService {
  final SqliteDb localDb;
  final _http = HttpService();

  SyncService({required this.localDb});

  Future<void> syncAll() async {
    await syncProviders();
    await syncServices();
  }

  Future<void> syncProviders() async {
    try {
      final db = await localDb.database;
      final lastSync = await localDb.getLastSync('providers');

      final response =
          await _http.get<Map<String, dynamic>, Map<String, dynamic>>(
        lastSync != null ? '/providers?lastSync=$lastSync' : '/providers',
        acceptedCodes: {200, 204},
      );

      final List<dynamic> providers = response['data'] ?? [];

      await db.transaction((txn) async {
        for (var provider in providers) {
          provider['available'] = provider['available'] == true ? 1 : 0;
          provider['show_in_app'] = provider['show_in_app'] == true ? 1 : 0;
          await txn.insert(
            'providers',
            provider,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      await localDb.updateLastSync('providers');
    } catch (e) {
      logger.e('Error syncing providers: $e');
      rethrow;
    }
  }

  Future<void> syncServices() async {
    try {
      final db = await localDb.database;
      final lastSync = await localDb.getLastSync('services');

      final response =
          await _http.get<Map<String, dynamic>, Map<String, dynamic>>(
        lastSync != null ? '/services?lastSync=$lastSync' : '/services',
        acceptedCodes: {200, 204},
      );

      final List<dynamic> services = response['data'] ?? [];

      await db.transaction((txn) async {
        for (var service in services) {
          await txn.insert(
            'services',
            service,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      await localDb.updateLastSync('services');
    } catch (e) {
      logger.e('Error syncing services: $e');
      rethrow;
    }
  }
}
