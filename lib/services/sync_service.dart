import 'dart:convert';

import 'package:baarazon_data/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import '../database/sqlite_db.dart';

class SyncService {
  final SqliteDb localDb;

  SyncService({required this.localDb});

  Future<void> syncAll() async {
    await syncProviders();
    await syncServices();
  }

  Future<void> syncProviders() async {
    try {
      final db = await localDb.database;
      // Get last sync timestamp for providers
      final lastSync = await localDb.getLastSync('providers');

      // Fetch only updated records from Supabase
      final response = await http
          .get(Uri.parse('$API_URL/get_all_providers?lastSync=$lastSync'));

      final Map<String, dynamic> responseJson = jsonDecode(response.body);
      final List<dynamic> providers = responseJson['data'];

      // Begin transaction
      await db.transaction((txn) async {
        for (var provider in providers) {
          await txn.insert(
            'providers',
            provider,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      // Update sync timestamp
      await localDb.updateLastSync('providers');
    } catch (e) {
      print('Error syncing providers: $e');
      rethrow;
    }
  }

  Future<void> syncServices() async {
    try {
      final db = await localDb.database;
      final lastSync = await localDb.getLastSync('services');

      final response = await http
          .get(Uri.parse('$API_URL/get_all_services?lastSync=$lastSync'));

      final Map<String, dynamic> responseJson = jsonDecode(response.body);
      final List<dynamic> services = responseJson['data'];

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
      print('Error syncing services: $e');
      rethrow;
    }
  }
}
