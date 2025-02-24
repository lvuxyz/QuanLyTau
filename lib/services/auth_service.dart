import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class AuthService {
  bool get isAndroid => Platform.isAndroid;

  String get baseUrl {
    if (isAndroid) {
      return 'http://192.19.14.24:3000/api/v1'; // Replace with your computer's IP address
    } else {
      return 'http://localhost:3000/api/v1'; // For iOS or Web
    }
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('🔍 Attempting login with username: $username');

      // For testing purposes, we'll use a mock successful login
      // In a real app, you would make an HTTP request to your server
      if (username.isNotEmpty && password.isNotEmpty) {
        // Mock a delay for the API call
        await Future.delayed(Duration(seconds: 1));

        // Create a mock response
        final userData = {
          'id': '1',
          'username': username,
          'email': '$username@example.com',
          'name': 'Test User',
          'role': 'admin',
          'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        };

        // Save the token
        await _saveToken(userData['token']!);

        print('✅ Login successful for user: $username');
        return {
          'success': true,
          'data': userData
        };
      } else {
        print('❌ Login failed: Empty credentials');
        return {
          'success': false,
          'message': 'Tài khoản hoặc mật khẩu không được để trống'
        };
      }

      /*
      // Real API implementation (commented out for mock version)
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          final data = responseData['data'];

          // Check if `data` is null or doesn't contain `token`
          if (data == null || !data.containsKey('token')) {
            return {
              'success': false,
              'message': 'Invalid API response (missing data)'
            };
          }

          // Save token
          await _saveToken(data['token']);

          return {
            'success': true,
            'data': data
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Login failed'
          };
        }
      } else {
        return {
          'success': false,
          'message': _handleErrorResponse(response)
        };
      }
      */
    } catch (e) {
      print('❌ Login error: $e');
      return {
        'success': false,
        'message': 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng'
      };
    }
  }

  String _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      return errorData['message'] ?? 'Lỗi không xác định';
    } catch (e) {
      return 'Lỗi máy chủ (Mã lỗi: ${response.statusCode})';
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      print('✅ Token saved successfully');
    } catch (e) {
      print('❌ Error saving token: $e');
    }
  }
}