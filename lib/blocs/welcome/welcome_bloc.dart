import 'package:flutter_bloc/flutter_bloc.dart';
import 'welcome_event.dart';
import 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(InitialState());

  @override
  Stream<WelcomeState> mapEventToState(WelcomeEvent event) async* {
    if (event is NavigateToLoginEvent) {
      // Thực hiện điều hướng đến màn hình đăng nhập
      // Giả sử bạn đang dùng Navigator để điều hướng
      yield NavigateToLoginState();
    } else if (event is NavigateToRegisterEvent) {
      // Điều hướng đến màn hình đăng ký
      yield NavigateToRegisterState();
    }
  }
}
