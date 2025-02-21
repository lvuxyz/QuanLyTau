import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/welcome/welcome_bloc.dart';
import '../blocs/welcome/welcome_event.dart';
import '../blocs/welcome/welcome_state.dart';
import 'login_screen.dart';
import 'register_screen.dart'; // Import for the RegisterScreen

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: BlocListener<WelcomeBloc, WelcomeState>(
        listener: (context, state) {
          if (state is NavigateToLoginState) {
            // Navigate to login screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else if (state is NavigateToRegisterState) {
            // Navigate to register screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1A1A1A),
                const Color(0xFF222222),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_boat_rounded,
                    size: 100,
                    color: const Color(0xFF13B8A8),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Chào mừng bạn đã đến với\nứng dụng quản lý tàu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      height: 1.3,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Quản lý hiệu quả với công nghệ hiện đại',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.08),
                  _buildButton(
                    context: context,
                    text: 'Đăng nhập',
                    onPressed: () {
                      // Add the navigation event to the bloc
                      BlocProvider.of<WelcomeBloc>(context).add(NavigateToLoginEvent());
                    },
                    isPrimary: true,
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    context: context,
                    text: 'Đăng ký',
                    onPressed: () {
                      // Add the navigation event to the bloc
                      BlocProvider.of<WelcomeBloc>(context).add(NavigateToRegisterEvent());
                    },
                    isPrimary: false,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phiên bản 1.0.0',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Ship Manager',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        boxShadow: isPrimary
            ? [
          BoxShadow(
            color: const Color(0xFF13B8A8).withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? const Color(0xFF13B8A8)
              : Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(color: Color(0xFF13B8A8), width: 2),
          ),
          elevation: isPrimary ? 0 : 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}