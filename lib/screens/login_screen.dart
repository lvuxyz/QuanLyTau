import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/login/login_bloc.dart';
import '../services/auth_service.dart';
import '../blocs/login/login_event.dart';
import '../blocs/login/login_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authService: AuthService()), // ✅ Fix lỗi thiếu authService
      child: Scaffold(
        appBar: AppBar(title: Text('Đăng nhập')),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('🎉 Đăng nhập thành công!')),
              );
              Navigator.pop(context);
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
              );
            } else if (state is NetworkError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.orange),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Tài khoản'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Mật khẩu'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: (state is LoginLoading) ? null : () {
                      if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('⚠️ Vui lòng nhập tài khoản và mật khẩu')),
                        );
                        return;
                      }

                      context.read<LoginBloc>().add(
                        LoginButtonPressed(
                          username: _usernameController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                    child: (state is LoginLoading)
                        ? CircularProgressIndicator()
                        : Text('Đăng nhập'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
