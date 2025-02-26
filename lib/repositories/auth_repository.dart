import '../data/remote/auth_service.dart';
import '../data/local/preferences_helper.dart';
import '../models/user.dart';

class AuthRepository {
  final AuthService _authService;
  final PreferencesHelper _preferencesHelper;

  AuthRepository({
    AuthService? authService,
    PreferencesHelper? preferencesHelper,
  }) :
        _authService = authService ?? AuthService(),
        _preferencesHelper = preferencesHelper ?? PreferencesHelper();

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final result = await _authService.login(username, password);

      if (result['success'] == true) {
        // Lưu token
        await _preferencesHelper.saveToken(result['data']['token']);
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: ${e.toString()}'
      };
    }
  }

  Future<String?> getToken() async {
    return await _preferencesHelper.getToken();
  }

  Future<User> getCurrentUser() async {
    // Lấy thông tin người dùng từ token đã lưu
    final token = await _preferencesHelper.getToken();
    // Giả lập dữ liệu người dùng
    return User(
      id: '1',
      username: 'admin',
      email: 'admin@example.com',
      role: 'admin',
      token: token ?? '',
    );
  }

  Future<void> logout() async {
    await _preferencesHelper.clearToken();
  }
}