import 'dart:convert';

import 'package:baarazon_data/constants.dart';
import 'package:baarazon_data/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import '../database/sqlite_db.dart';
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
        lastSync != null
            ? '/get_all_providers?lastSync=$lastSync'
            : '/get_all_providers',
        acceptedCodes: {200, 204},
      );

      final List<dynamic> providers = response['data'] ?? [];

      await db.transaction((txn) async {
        for (var provider in providers) {
          provider['available'] = provider['available'] == true ? 1 : 0;
          provider['show_in_app'] = provider['show_in_app'] == true ? 1 : 0;
          logger.d({provider});
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
        '/get_all_services',
        headers: lastSync != null ? {'Last-Sync': lastSync} : null,
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
