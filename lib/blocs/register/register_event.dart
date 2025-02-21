abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterButtonPressed({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

class BackToLoginPressed extends RegisterEvent {}
