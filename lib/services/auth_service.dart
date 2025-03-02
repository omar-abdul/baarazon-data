import 'dart:async';

import '../logger.dart';
import '../services/http_service.dart';
import '../services/preferences_service.dart';

class AuthService {
  final _http = HttpService();

  Future<String?> login(String phoneNumber) async {
    logger.d('login: $phoneNumber');
    final response =
        await _http.post<Map<String, dynamic>, Map<String, dynamic>>(
      '/signup-signin',
      body: {'phone_number': phoneNumber},
      acceptedCodes: {200, 409},
    );

    final error = response['error'];
    if (error != null) {
      return error;
    }
    await PreferencesService.setPhoneNumber(phoneNumber);
    return null;
  }

  Future<bool> verifyToken(String token) async {
    try {
      await _http.get(
        '/verify-token',
        headers: {'Authorization': 'Bearer $token'},
        acceptedCodes: {200},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String otp) async {
    final response =
        await _http.post<Map<String, dynamic>, Map<String, dynamic>>(
      '/verify-otp',
      body: {'otp': otp},
      acceptedCodes: {200},
    );
    final token = response['token'];
    final error = response['error'];
    if (error == null) {
      await PreferencesService.setToken(token);
      return {'token': token, 'error': null};
    }
    return {'token': null, 'error': error};
  }

  Future<void> logout() async {
    await PreferencesService.removeToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await PreferencesService.getToken();
    if (token == null) return false;
    return verifyToken(token);
  }
}
