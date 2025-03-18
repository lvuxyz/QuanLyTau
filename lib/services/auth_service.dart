import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'api_service.dart';

class AuthService extends ApiService {
  bool get isAndroid => Platform.isAndroid;

  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://192.168.2.37:3000/api/v1'; // Sử dụng địa chỉ IP thực tế của máy tính trong mạng WiFi
    } else {
      return 'http://localhost:3000/api/v1'; // Cho iOS hoặc Web
    }
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Login method
  Future<Map<String, dynamic>> login(String username, String password) async {
    return await post('auth/login', {
      'username': username,
      'password': password
    }, requiresAuth: false);
  }

  // Register method
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    return await post('auth/register', userData, requiresAuth: false);
  }

  // Logout method
  Future<Map<String, dynamic>> logout() async {
    try {
      // Gọi API logout nếu cần
      final result = await post('auth/logout', {});
      
      // Xóa token bất kể API thành công hay thất bại
      await _deleteToken();
      
      return result;
    } catch (e) {
      print('❌ Lỗi đăng xuất: $e');
      // Xóa token ngay cả khi có lỗi
      await _deleteToken();
      return {
        'success': true,
        'message': 'Đã đăng xuất khỏi thiết bị'
      };
    }
  }

  // Forgot password method
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return await post('auth/forgot-password', {'email': email}, requiresAuth: false);
  }

  // Reset password method
  Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    return await post('auth/reset-password', {
      'token': token,
      'password': newPassword
    }, requiresAuth: false);
  }

  // Change password method
  Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword) async {
    return await put('auth/change-password', {
      'currentPassword': currentPassword,
      'newPassword': newPassword
    });
  }

  // Get current user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    return await get('auth/profile');
  }

  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> profileData) async {
    return await put('auth/profile', profileData);
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

  Future<void> _deleteToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      print('✅ Token đã được xóa thành công');
    } catch (e) {
      print('❌ Lỗi khi xóa token: $e');
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    return await post('auth/refresh-token', {}, requiresAuth: true);
  }
}