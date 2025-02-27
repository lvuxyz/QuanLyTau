import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipmanagerapp/models/user.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationUninitialized()) {
    on<AppStarted>((event, emit) async {
      final token = await _getToken();
      if (token != null) {
        try {
          // Get user data from local storage
          final userData = await _getUserData();
          if (userData != null) {
            emit(AuthenticationAuthenticated(userData: userData));
          } else {
            emit(AuthenticationUnauthenticated());
            await _deleteToken();
          }
        } catch (_) {
          emit(AuthenticationUnauthenticated());
          await _deleteToken();
        }
      } else {
        emit(AuthenticationUnauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthenticationLoading());
      await _persistToken(event.token);
      await _persistUserData(event.userData);
      emit(AuthenticationAuthenticated(userData: event.userData));
    });

    on<LoggedOut>((event, emit) async {
      emit(AuthenticationLoading());
      await _deleteToken();
      await _deleteUserData();
      emit(AuthenticationUnauthenticated());
    });
  }

  Future<void> _persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _persistUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', User.fromJson(userData).toJson().toString());
  }

  Future<void> _deleteUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      // Parse the user data string back to a Map
      // This implementation may need adjustment based on how you serialize your User model
      try {
        final user = User.fromJson(Map<String, dynamic>.from(userDataString as Map));
        return user.toJson();
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}