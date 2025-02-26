import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class AuthService {
  bool get isAndroid => Platform.isAndroid;

  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api/v1';
    } else {
      return 'http://localhost:3000/api/v1';
    }
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('🔍 Đang thử đăng nhập với tên người dùng: $username');

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

          if (data == null || !data.containsKey('token')) {
            return {
              'success': false,
              'message': 'Phản hồi API không hợp lệ (thiếu dữ liệu)'
            };
          }

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
}