import 'dart:io';
import 'package:baarazon_data/services/preferences_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import '../database/sqlite_db.dart';
import '../logger.dart';
import 'http_service.dart';
import 'sync_service.dart';

class FirebaseService {
  late FirebaseMessaging _messaging;

  Future<void> initialize() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    // Request permission with provisional option for iOS
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    // Check what the user has authorized
    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        logger.i('User granted permission');
        await _setupToken();
        break;
      case AuthorizationStatus.provisional:
        logger.i('User granted provisional permission');
        await _setupToken();
        break;
      case AuthorizationStatus.denied:
        logger.i('User declined permission');
        return; // Don't proceed with token setup
      case AuthorizationStatus.notDetermined:
        logger.i('Permission not determined');
        return; // Don't proceed with token setup
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      logger.i('FCM Token refreshed: $newToken');
      _saveTokenToServer(newToken);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        logger.d('FIREBASE MESSAGE HANDLER');
      }
    });
  }

  Future<void> _setupToken() async {
    if (Platform.isIOS) {
      final apnsToken = await _messaging.getAPNSToken();
      if (apnsToken != null) {
        final fcmToken = await _messaging.getToken();
        await _saveTokenToServer(fcmToken);
      }
    } else {
      final fcmToken = await _messaging.getToken();
      await _saveTokenToServer(fcmToken);
    }
  }

  Future<void> _saveTokenToServer(String? fcmToken) async {
    var hasConnected = await Connectivity().checkConnectivity();
    if (hasConnected.contains(ConnectivityResult.none)) return;

    if (fcmToken == null) return;

    final authToken = await PreferencesService.getToken();
    if (authToken == null) return;

    await HttpService().post('/update-user-fcm-token', body: {
      'fcm_token': fcmToken,
    }, headers: {
      'Authorization': 'Bearer $authToken',
    }, acceptedCodes: {
      200,
      201
    });
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    var localDb = SqliteDb();
    await localDb.database;
    logger.d('FIREBASE MESSAGE HANDLER BACKGROUND');
    await SyncService(localDb: localDb).syncAll();
  }
}
