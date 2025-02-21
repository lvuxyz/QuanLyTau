import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/welcome/welcome_bloc.dart';
import '../blocs/welcome/welcome_event.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Màu nền theo yêu cầu
      body: Container(
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
                // Logo hoặc Icon ứng dụng
                Icon(
                  Icons.directions_boat_rounded,
                  size: 100,
                  color: const Color(0xFF13B8A8),
                ),
                const SizedBox(height: 30),

                // Tiêu đề chào mừng
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

                // Mô tả nhỏ (tuỳ chọn)
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

                // Nút đăng nhập
                _buildButton(
                  context: context,
                  text: 'Đăng nhập',
                  onPressed: () {
                    context.read<WelcomeBloc>().add(NavigateToLoginEvent());
                  },
                  isPrimary: true,
                ),

                const SizedBox(height: 16),

                // Nút đăng ký
                _buildButton(
                  context: context,
                  text: 'Đăng ký',
                  onPressed: () {
                    context.read<WelcomeBloc>().add(NavigateToRegisterEvent());
                  },
                  isPrimary: false,
                ),

                const SizedBox(height: 24),

                // Căn chỉnh "Phiên bản 1.0.0" ở góc dưới bên trái
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, bottom: 24.0),
                    child: Text(
                      'Phiên bản 1.0.0',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
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
