import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/welcome/welcome_bloc.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());  // Sử dụng 'const' khi gọi MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);  // Thêm 'const' vào constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý tàu',
      debugShowCheckedModeBanner: false,  // Tắt banner "debug"
      home: BlocProvider(
        create: (context) => WelcomeBloc(),
        child: WelcomeScreen(),
      ),
    );
  }
}
