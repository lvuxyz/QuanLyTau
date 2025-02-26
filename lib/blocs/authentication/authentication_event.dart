import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {
  final Map<String, dynamic> user;

  const AuthenticationLoggedIn({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthenticationLoggedOut extends AuthenticationEvent {}