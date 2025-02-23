// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class AuthService {
  bool get isAndroid => Platform.isAndroid;

  String get baseUrl => isAndroid
      ? 'http://10.0.2.2:3000/api/v1'
      : 'http://localhost:3000/api/v1';

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('Attempting login with URL: $baseUrl/auth/login');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success']) {
          if (responseData['data'] != null && responseData['data']['token'] != null) {
            await _saveToken(responseData['data']['token']);
          }
          return {
            'success': true,
            'data': responseData['data']
          };
        }
        return {
          'success': false,
          'message': responseData['message'] ?? 'Đăng nhập thất bại'
        };
      } else {
        return {
          'success': false,
          'message': _handleErrorResponse(response)
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.'
      };
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'email': email}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Yêu cầu đặt lại mật khẩu đã được gửi'
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Không thể gửi yêu cầu đặt lại mật khẩu'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Không thể kết nối đến máy chủ'
      };
    }
  }

  String _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      return errorData['message'] ?? _getDefaultErrorMessage(response.statusCode);
    } catch (e) {
      return _getDefaultErrorMessage(response.statusCode);
    }
  }

  String _getDefaultErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Dữ liệu không hợp lệ';
      case 401:
        return 'Tài khoản hoặc mật khẩu không chính xác';
      case 403:
        return 'Không có quyền truy cập';
      case 404:
        return 'Không tìm thấy tài nguyên';
      case 500:
        return 'Lỗi máy chủ';
      default:
        return 'Đã có lỗi xảy ra (Mã lỗi: $statusCode)';
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      print('Token saved successfully');
    } catch (e) {
      print('Error saving token: $e');
      throw Exception('Không thể lưu token xác thực');
    }
  }
}