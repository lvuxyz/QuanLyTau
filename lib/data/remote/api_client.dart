import 'dart:convert';
import 'package:http/http.dart' as http;
import '../local/preferences_helper.dart';
import 'dart:io' show Platform;

class ApiClient {
  final http.Client _httpClient;
  final PreferencesHelper _preferencesHelper;

  ApiClient({
    http.Client? httpClient,
    PreferencesHelper? preferencesHelper,
  }) :
        _httpClient = httpClient ?? http.Client(),
        _preferencesHelper = preferencesHelper ?? PreferencesHelper();

  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api/v1';
    } else {
      return 'http://localhost:3000/api/v1';
    }
  }

  Future<Map<String, String>> _getHeaders({bool needsAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (needsAuth) {
      final token = await _preferencesHelper.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint, {bool needsAuth = true}) async {
    try {
      final headers = await _getHeaders(needsAuth: needsAuth);
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> data,
      {bool needsAuth = true}
      ) async {
    try {
      final headers = await _getHeaders(needsAuth: needsAuth);
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: ${e.toString()}'
      };
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      try {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Lỗi máy chủ'
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Lỗi máy chủ (${response.statusCode})'
        };
      }
    }
  }
}