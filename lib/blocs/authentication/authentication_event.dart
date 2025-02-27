abstract class AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;
  final Map<String, dynamic> userData;

  LoggedIn({required this.token, required this.userData});
}

class LoggedOut extends AuthenticationEvent {}