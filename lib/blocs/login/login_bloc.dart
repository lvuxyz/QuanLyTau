import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  LoginBloc({required this.authService}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        print('🛠 Đang gửi yêu cầu đăng nhập...');

        final result = await authService.login(
          event.username,
          event.password,
        );

        if (result['success'] == true) {
          print('✅ Đăng nhập thành công');
          emit(LoginSuccess(userData: result['data']));
        } else {
          print('❌ Lỗi đăng nhập: ${result['message']}');
          emit(LoginFailure(errorMessage: result['message']));
        }
      } catch (e) {
        print('⚠️ Lỗi kết nối đến máy chủ: $e');
        emit(NetworkError(
          message: 'Không thể kết nối đến máy chủ. Vui lòng thử lại sau.',
        ));
      }
    });

    on<LoginReset>((event, emit) {
      emit(LoginInitial());
    });
  }
}