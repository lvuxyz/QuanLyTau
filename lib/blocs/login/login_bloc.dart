// lib/blocs/login/login_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        final result = await authRepository.login(
          event.username,
          event.password,
        );

        if (result['success']) {
          emit(LoginSuccess(userData: result['data']));
        } else {
          emit(LoginFailure(errorMessage: result['message']));
        }
      } catch (e) {
        emit(NetworkError(
          message: 'Không thể kết nối đến máy chủ. Vui lòng thử lại sau.',
        ));
      }
    });

    on<LoginReset>((event, emit) {
      emit(LoginInitial());
    });

    on<ForgotPasswordPressed>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        // In a real application, implement the forgot password logic here
        // For now, we'll just simulate a successful response
        await Future.delayed(Duration(seconds: 1));
        emit(ForgotPasswordSuccess(message: 'Đã gửi email đặt lại mật khẩu'));
      } catch (e) {
        emit(ForgotPasswordFailure(
            errorMessage: 'Không thể gửi email đặt lại mật khẩu. Vui lòng thử lại sau.'
        ));
      }
    });
  }
}