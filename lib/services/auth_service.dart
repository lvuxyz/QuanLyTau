import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class AuthService {
  bool get isAndroid => Platform.isAndroid;

  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://192.19.14.24:3000/api/v1'; // Sử dụng địa chỉ IP thực tế của máy tính trong mạng WiFi
    } else {
      return 'http://localhost:3000/api/v1'; // Cho iOS hoặc Web
    }
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('🔍 Đang thử đăng nhập với tên người dùng: $username');

      // Gửi yêu cầu HTTP đến máy chủ
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      print('📥 Trạng thái phản hồi: ${response.statusCode}');
      print('📥 Nội dung phản hồi: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          final data = responseData['data'];

          // Kiểm tra nếu `data` là null hoặc không chứa `token`
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

      // Giữ lại hệ thống giả lập như fallback cho trường hợp máy chủ không hoạt động
      /*
      if (username.isNotEmpty && password.isNotEmpty) {
        await Future.delayed(Duration(seconds: 1));
        final userData = {
          'id': '1',
          'username': username,
          'email': '$username@example.com',
          'name': 'Test User',
          'role': 'admin',
          'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
        };
        await _saveToken(userData['token']!);
        return {
          'success': true,
          'data': userData
        };
      } else {
        return {
          'success': false,
          'message': 'Tài khoản hoặc mật khẩu không được để trống'
        };
      }
      */
    } catch (e) {
      print('❌ Lỗi đăng nhập: $e');
      return {
        'success': false,
        'message': 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng'
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
      print('✅ Token đã được lưu thành công');
    } catch (e) {
      print('❌ Lỗi khi lưu token: $e');
    }
  }
}