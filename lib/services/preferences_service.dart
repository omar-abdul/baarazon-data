import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static SharedPreferences? _preferences;
  static const String _tokenKey = 'auth_token';

  static Future<SharedPreferences> get instance async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  // Helper methods
  static Future<bool> isFirstLaunch() async {
    final prefs = await instance;
    return prefs.getBool('isFirstLaunch') ?? true;
  }

  static Future<void> setFirstLaunch(bool value) async {
    final prefs = await instance;
    await prefs.setBool('isFirstLaunch', value);
  }

  static Future<String?> getToken() async {
    final prefs = await instance;
    return prefs.getString(_tokenKey);
  }

  static Future<void> setToken(String token) async {
    final prefs = await instance;
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> removeToken() async {
    final prefs = await instance;
    await prefs.remove(_tokenKey);
  }

  static Future<void> setPhoneNumber(String phoneNumber) async {
    final prefs = await instance;
    await prefs.setString('phoneNumber', phoneNumber);
  }

  static Future<void> removePhoneNumber() async {
    final prefs = await instance;
    await prefs.remove('phoneNumber');
  }

  static Future<String?> getPhoneNumber() async {
    final prefs = await instance;
    return prefs.getString('phoneNumber');
  }
}
