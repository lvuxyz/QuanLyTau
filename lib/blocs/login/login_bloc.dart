import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    // Register event handlers using the on<EventType> method
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        // Simulate authentication logic
        await Future.delayed(Duration(seconds: 1)); // Simulated API call delay

        if (event.username == 'user' && event.password == 'password') {
          emit(LoginSuccess());
        } else {
          emit(LoginFailure(errorMessage: 'Sai tài khoản hoặc mật khẩu'));
        }
      } catch (e) {
        emit(LoginFailure(errorMessage: 'Đã có lỗi xảy ra'));
      }
    });

    on<ForgotPasswordPressed>((event, emit) {
      emit(LoginFailure(errorMessage: 'Chức năng quên mật khẩu chưa được cài đặt'));
    });
  }
}