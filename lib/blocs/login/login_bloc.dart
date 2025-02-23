// lib/blocs/login/login_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  LoginBloc({AuthService? authService})
      : authService = authService ?? AuthService(),
        super(LoginInitial()) {

    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        final result = await authService!.login(
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
            message: 'Không thể kết nối đến máy chủ. Vui lòng thử lại sau.'
        ));
      }
    });

    on<ForgotPasswordPressed>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        final result = await authService!.forgotPassword(event.email);

        if (result['success']) {
          emit(ForgotPasswordSuccess(message: result['message']));
        } else {
          emit(ForgotPasswordFailure(errorMessage: result['message']));
        }
      } catch (e) {
        emit(ForgotPasswordFailure(
            errorMessage: 'Không thể kết nối đến máy chủ. Vui lòng thử lại sau.'
        ));
      }
    });

    on<LoginReset>((event, emit) {
      emit(LoginInitial());
    });
  }
}