// services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://your-api-url.com/api/v1'; // Thay thế bằng URL của API

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Lưu token vào SharedPreferences hoặc secure storage
        await _saveToken(responseData['token']);
        return {'success': true, 'data': responseData};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Đăng nhập thất bại'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Đã có lỗi xảy ra: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': responseData['message'] ?? 'Yêu cầu đặt lại mật khẩu đã được gửi'};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Không thể gửi yêu cầu đặt lại mật khẩu'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Đã có lỗi xảy ra: ${e.toString()}'};
    }
  }

  // Phương thức riêng tư để lưu token
  Future<void> _saveToken(String token) async {
    // Sử dụng shared_preferences hoặc flutter_secure_storage để lưu token
    // Ví dụ với shared_preferences:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('auth_token', token);
  }
}