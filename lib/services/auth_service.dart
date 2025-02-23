import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class AuthService {
  bool get isAndroid => Platform.isAndroid;

  String get baseUrl {
    if (isAndroid) {
      return 'http://192.19.14.24:3000/api/v1'; // Thay địa chỉ IP máy tính vào đây
    } else {
      return 'http://localhost:3000/api/v1'; // Dành cho iOS hoặc Web
    }
  }


  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('🔍 Sending POST request to: $baseUrl/auth/login');
      print('📤 Request body: {"username": "$username", "password": "$password"}');

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

          // Kiểm tra nếu `data` null hoặc không chứa `token`
          if (data == null || !data.containsKey('token')) {
            return {
              'success': false,
              'message': 'Phản hồi API không hợp lệ (thiếu dữ liệu)'
            };
          }

          // Lưu token
          await _saveToken(data['token']);

          return {
            'success': true,
            'data': data
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Đăng nhập thất bại'
          };
        }
      } else {
        return {
          'success': false,
          'message': _handleErrorResponse(response)
        };
      }
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
