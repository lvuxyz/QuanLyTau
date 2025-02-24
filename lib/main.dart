import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/welcome/welcome_bloc.dart';  // Import WelcomeBloc
import 'screens/welcome_screen.dart';  // Import màn hình WelcomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WelcomeBloc(), // Cung cấp WelcomeBloc ở đây
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ship Manager',
        home: WelcomeScreen(),  // Màn hình bắt đầu của ứng dụng
      ),
    );
  }
}
