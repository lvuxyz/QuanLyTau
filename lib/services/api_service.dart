import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class ApiService {
  bool get isAndroid => Platform.isAndroid;

  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://192.168.2.37:3000/api/v1'; // Use the actual IP address of your computer on the WiFi network
    } else {
      return 'http://localhost:3000/api/v1'; // For iOS or Web
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, String>> get _authHeaders async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Generic GET request
  Future<Map<String, dynamic>> get(String endpoint, {bool requiresAuth = true}) async {
    try {
      print('🔍 GET request to: $endpoint');
      
      final headers = requiresAuth ? await _authHeaders : _headers;
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      print('📥 Response status: ${response.statusCode}');
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Error in GET request: $e');
      return {
        'success': false,
        'message': 'Cannot connect to server. Please check your network connection'
      };
    }
  }

  // Generic POST request
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data, {bool requiresAuth = true}) async {
    try {
      print('🔍 POST request to: $endpoint');
      
      final headers = requiresAuth ? await _authHeaders : _headers;
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      print('📥 Response status: ${response.statusCode}');
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Error in POST request: $e');
      return {
        'success': false,
        'message': 'Cannot connect to server. Please check your network connection'
      };
    }
  }

  // Generic PUT request
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic>? data, {bool requiresAuth = true}) async {
    try {
      print('🔍 PUT request to: $endpoint');
      
      final headers = requiresAuth ? await _authHeaders : _headers;
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: data != null ? json.encode(data) : null,
      );

      print('📥 Response status: ${response.statusCode}');
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Error in PUT request: $e');
      return {
        'success': false,
        'message': 'Cannot connect to server. Please check your network connection'
      };
    }
  }

  // Generic DELETE request
  Future<Map<String, dynamic>> delete(String endpoint, {bool requiresAuth = true}) async {
    try {
      print('🔍 DELETE request to: $endpoint');
      
      final headers = requiresAuth ? await _authHeaders : _headers;
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );

      print('📥 Response status: ${response.statusCode}');
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Error in DELETE request: $e');
      return {
        'success': false,
        'message': 'Cannot connect to server. Please check your network connection'
      };
    }
  }

  // Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final responseData = json.decode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseData['success'] == true) {
          return {
            'success': true,
            'data': responseData['data'],
            'message': responseData['message']
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Unknown error'
          };
        }
      } else {
        return {
          'success': false,
          'message': _handleErrorResponse(response)
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error processing response: $e'
      };
    }
  }

  String _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      return errorData['message'] ?? 'Unknown error';
    } catch (e) {
      return 'Server error (Error code: ${response.statusCode})';
    }
  }
} 