import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      try {
        // Validate input
        if (event.username.isEmpty || event.email.isEmpty ||
            event.password.isEmpty || event.confirmPassword.isEmpty) {
          emit(RegisterFailure(errorMessage: 'Vui lòng điền đầy đủ thông tin'));
          return;
        }

        if (event.password != event.confirmPassword) {
          emit(RegisterFailure(errorMessage: 'Mật khẩu không khớp'));
          return;
        }

        // Simulate API call
        await Future.delayed(Duration(seconds: 1));

        // For demo purposes, always succeed
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(errorMessage: 'Đã có lỗi xảy ra: ${e.toString()}'));
      }
    });

    on<BackToLoginPressed>((event, emit) {
      // Handle navigation in the UI
    });
  }
}