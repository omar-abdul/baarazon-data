import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../logger.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  final http.Client _client = http.Client();

  // Singleton pattern
  factory HttpService() => _instance;

  HttpService._internal();

  Future<K> get<K, T>(
    String endpoint, {
    K Function(dynamic)? fromJson,
    Map<String, String>? headers,
    Set<int>? acceptedCodes,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$apiUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      );

      if (response.statusCode == 200 ||
          acceptedCodes?.contains(response.statusCode) == true) {
        final data = jsonDecode(response.body);
        logger.d(data);
        return fromJson != null ? fromJson(data) : data as K;
      }

      throw HttpException('Failed to load data: ${response.statusCode}');
    } catch (e) {
      throw HttpException('Network error: $e');
    }
  }

  Future<K> post<K, T>(
    String endpoint, {
    required dynamic body,
    K Function(dynamic)? fromJson,
    Map<String, String>? headers,
    Set<int>? acceptedCodes,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$apiUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 ||
          acceptedCodes?.contains(response.statusCode) == true) {
        final data = jsonDecode(response.body);
        return fromJson != null ? fromJson(data) : data as K;
      }

      throw HttpException('Failed to post data: ${response.statusCode}');
    } catch (e) {
      throw HttpException('Network error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
