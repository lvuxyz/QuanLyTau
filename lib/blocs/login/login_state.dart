// blocs/login/login_state.dart
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> userData;

  LoginSuccess({required this.userData});
}

class LoginFailure extends LoginState {
  final String errorMessage;

  LoginFailure({required this.errorMessage});
}

class ForgotPasswordLoading extends LoginState {}

class ForgotPasswordSuccess extends LoginState {
  final String message;

  ForgotPasswordSuccess({required this.message});
}

class ForgotPasswordFailure extends LoginState {
  final String errorMessage;

  ForgotPasswordFailure({required this.errorMessage});
}