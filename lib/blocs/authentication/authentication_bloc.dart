import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;

  AuthenticationBloc({required this.authRepository}) : super(AuthenticationInitial()) {
    on<AuthenticationStarted>((event, emit) async {
      try {
        final token = await authRepository.getToken();
        if (token != null && token.isNotEmpty) {
          final userData = await authRepository.getCurrentUser();
          emit(AuthenticationSuccess(user: userData.toJson()));
        } else {
          emit(AuthenticationUnauthenticated());
        }
      } catch (e) {
        emit(AuthenticationFailure(message: e.toString()));
      }
    });

    on<AuthenticationLoggedIn>((event, emit) {
      emit(AuthenticationSuccess(user: event.user));
    });

    on<AuthenticationLoggedOut>((event, emit) async {
      await authRepository.logout();
      emit(AuthenticationUnauthenticated());
    });
  }
}