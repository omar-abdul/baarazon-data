import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';
import '../database/sqlite_db.dart';
import 'sync_service.dart';

// This needs to be top-level function
var logger = Logger();
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      // Initialize services

      final localDb = SqliteDb();
      await localDb.initializeDatabase();

      final syncService = SyncService(
        localDb: localDb,
      );

      // Perform sync
      await syncService.syncAll();

      return true;
    } catch (e) {
      logger.e('Background sync failed: $e');
      return false;
    }
  });
}

class BackgroundSyncService {
  static const syncTaskName = 'com.baarazon.sync';

  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false, // Set to true for debugging
    );
  }

  static Future<void> registerPeriodicSync() async {
    await Workmanager().registerPeriodicTask(
      syncTaskName,
      syncTaskName,
      frequency: const Duration(hours: 6), // Sync every 6 hours
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      backoffPolicy: BackoffPolicy.exponential,
    );
  }

  static Future<void> cancelSync() async {
    await Workmanager().cancelByUniqueName(syncTaskName);
  }
}
