import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        // Giả sử bạn kiểm tra thông tin đăng nhập ở đây.
        // Thực hiện gọi API hoặc kiểm tra tài khoản mật khẩu
        if (event.username == 'user' && event.password == 'password') {
          yield LoginSuccess();
        } else {
          yield LoginFailure(errorMessage: 'Sai tài khoản hoặc mật khẩu');
        }
      } catch (e) {
        yield LoginFailure(errorMessage: 'Đã có lỗi xảy ra');
      }
    } else if (event is ForgotPasswordPressed) {
      // Xử lý sự kiện quên mật khẩu
      // Ví dụ: Chuyển đến màn hình quên mật khẩu
      yield LoginFailure(errorMessage: 'Chức năng quên mật khẩu chưa được cài đặt');
    }
  }
}
