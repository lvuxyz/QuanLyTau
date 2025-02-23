// lib/blocs/login/login_event.dart
abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({required this.username, required this.password});
}

class LoginReset extends LoginEvent {}

class ForgotPasswordPressed extends LoginEvent {
  final String email;

  ForgotPasswordPressed({required this.email});
}